param(
  [switch]$DryRun,
  [switch]$Apply,
  [int]$OlderThanDays = 2,
  [switch]$IncludePackageCaches = $true,
  [switch]$IncludeRuntimeCaches
)

$ErrorActionPreference = "SilentlyContinue"

if (-not $DryRun -and -not $Apply) {
  $DryRun = $true
}

$homePath = [Environment]::GetFolderPath("UserProfile")
$localAppData = [Environment]::GetFolderPath("LocalApplicationData")
$appData = [Environment]::GetFolderPath("ApplicationData")
$cutoff = (Get-Date).AddDays(-1 * $OlderThanDays)

function Get-TreeSize {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return 0 }
  $item = Get-Item -LiteralPath $Path -Force
  if (-not $item.PSIsContainer) { return [int64]$item.Length }
  return [int64]((Get-ChildItem -LiteralPath $Path -Force -Recurse | Measure-Object Length -Sum).Sum)
}

function Format-Bytes {
  param([int64]$Bytes)
  if ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
  if ($Bytes -ge 1MB) { return "{0:N1} MB" -f ($Bytes / 1MB) }
  if ($Bytes -ge 1KB) { return "{0:N1} KB" -f ($Bytes / 1KB) }
  return "$Bytes B"
}

function Test-UnderUserProfile {
  param([string]$Path)
  $resolved = (Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue).Path
  return ($resolved -and $resolved.StartsWith($homePath, [StringComparison]::OrdinalIgnoreCase))
}

function Add-ChildrenOlderThan {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$BasePath,
    [string]$Label
  )
  if (-not (Test-Path -LiteralPath $BasePath)) { return }
  if (-not (Test-UnderUserProfile -Path $BasePath)) { return }
  Get-ChildItem -LiteralPath $BasePath -Force |
    Where-Object { $_.LastWriteTime -lt $cutoff } |
    ForEach-Object {
      $List.Add([PSCustomObject]@{
        Label = $Label
        Path = $_.FullName
        Bytes = Get-TreeSize -Path $_.FullName
      })
    }
}

$targets = [System.Collections.Generic.List[object]]::new()

Add-ChildrenOlderThan -List $targets -BasePath ([IO.Path]::GetTempPath()) -Label "old system temp"
Add-ChildrenOlderThan -List $targets -BasePath (Join-Path $homePath ".codex\.tmp") -Label "old Codex temp"

$codexRoot = Join-Path $homePath ".codex"
if (Test-Path -LiteralPath $codexRoot) {
  Get-ChildItem -LiteralPath $codexRoot -Force -File |
    Where-Object { $_.Name -like "..codex-global-state.json.tmp-*" -and $_.LastWriteTime -lt $cutoff } |
    ForEach-Object {
      $targets.Add([PSCustomObject]@{
        Label = "stale Codex state temp"
        Path = $_.FullName
        Bytes = $_.Length
      })
    }
}

if ($IncludePackageCaches) {
  $cachePaths = @(
    @{ Label = "pip download cache"; Path = Join-Path $localAppData "pip\Cache" },
    @{ Label = "npm download cache"; Path = Join-Path $appData "npm-cache" },
    @{ Label = "npm user cache"; Path = Join-Path $homePath ".npm" },
    @{ Label = "yarn cache"; Path = Join-Path $homePath ".yarn\cache" },
    @{ Label = "pnpm store"; Path = Join-Path $homePath ".pnpm-store" },
    @{ Label = "selenium driver cache"; Path = Join-Path $homePath ".cache\selenium" }
  )

  foreach ($entry in $cachePaths) {
    if ((Test-Path -LiteralPath $entry.Path) -and (Test-UnderUserProfile -Path $entry.Path)) {
      $targets.Add([PSCustomObject]@{
        Label = $entry.Label
        Path = $entry.Path
        Bytes = Get-TreeSize -Path $entry.Path
      })
    }
  }
}

if ($IncludeRuntimeCaches) {
  $runtimePath = Join-Path $homePath ".cache\codex-runtimes"
  if ((Test-Path -LiteralPath $runtimePath) -and (Test-UnderUserProfile -Path $runtimePath)) {
    $targets.Add([PSCustomObject]@{
      Label = "Codex runtime cache"
      Path = $runtimePath
      Bytes = Get-TreeSize -Path $runtimePath
    })
  }
}

$totalBytes = [int64](($targets | Measure-Object Bytes -Sum).Sum)

if ($DryRun) {
  "Codex Cleaner dry run"
  "Would clean: $(Format-Bytes -Bytes $totalBytes)"
  $targets |
    Sort-Object Bytes -Descending |
    Select-Object Label, @{ Name = "Size"; Expression = { Format-Bytes -Bytes $_.Bytes } }, Path |
    Format-Table -AutoSize
  "Preserved: Codex sessions, plugins, skills, state databases, project files, and runtime caches unless -IncludeRuntimeCaches is set."
  exit 0
}

$removedBytes = 0
$removedCount = 0
$skipped = [System.Collections.Generic.List[string]]::new()

foreach ($target in $targets) {
  if (-not (Test-Path -LiteralPath $target.Path)) { continue }
  Remove-Item -LiteralPath $target.Path -Recurse -Force -ErrorAction SilentlyContinue
  if (Test-Path -LiteralPath $target.Path) {
    $skipped.Add($target.Path)
  } else {
    $removedBytes += [int64]$target.Bytes
    $removedCount += 1
  }
}

"Codex Cleaner completed"
"Removed: $(Format-Bytes -Bytes $removedBytes) across $removedCount top-level item(s)"
if ($skipped.Count -gt 0) {
  "Skipped because still present or in use:"
  $skipped | ForEach-Object { " - $_" }
}
"Preserved: Codex sessions, plugins, skills, state databases, project files, and runtime caches unless -IncludeRuntimeCaches was set."
