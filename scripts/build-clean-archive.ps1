param(
  [string] $OutputPath = (Join-Path ([System.IO.Path]::GetTempPath()) "openproject-work-package-required-fields.tar.gz")
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("op-wprf-package-" + [System.Guid]::NewGuid().ToString("N"))
$pluginDir = Join-Path $stageRoot "openproject-work-package-required-fields"

if (Test-Path $stageRoot) {
  Remove-Item -LiteralPath $stageRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $pluginDir | Out-Null

$directories = @(
  "app/controllers",
  "app/models",
  "app/views",
  "config",
  "db",
  "lib"
)

foreach ($directory in $directories) {
  $source = Join-Path $root $directory
  if (Test-Path $source) {
    $target = Join-Path $pluginDir $directory
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $target -Recurse
  }
}

$files = @(
  "Gemfile",
  "README.md",
  "openproject-work-package-required-fields.gemspec"
)

foreach ($file in $files) {
  Copy-Item -LiteralPath (Join-Path $root $file) -Destination (Join-Path $pluginDir $file)
}

$resolvedOutput = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
  $OutputPath
} else {
  Join-Path $root $OutputPath
}

if (Test-Path $resolvedOutput) {
  Remove-Item -LiteralPath $resolvedOutput -Force
}

Push-Location $stageRoot
try {
  tar -czf $resolvedOutput "openproject-work-package-required-fields"
} finally {
  Pop-Location
  Remove-Item -LiteralPath $stageRoot -Recurse -Force
}

Write-Host "Created $resolvedOutput"
