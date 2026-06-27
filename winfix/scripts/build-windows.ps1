param(
  [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ProjectRoot)) {
  throw "Project root does not exist: $ProjectRoot"
}

Set-Location $ProjectRoot
$env:CARGO_INCREMENTAL = "0"

$manifestPath = if ($env:PORTABLE_MANIFEST_PATH) {
  $env:PORTABLE_MANIFEST_PATH
} elseif (Test-Path "main/Cargo.toml") {
  "main/Cargo.toml"
} elseif (Test-Path "Cargo.toml") {
  "Cargo.toml"
} else {
  throw "Could not find Cargo.toml. Set PORTABLE_MANIFEST_PATH to the Cargo manifest to build."
}

$metadata = cargo metadata --no-deps --format-version 1 --manifest-path $manifestPath | ConvertFrom-Json
$packageId = if ($metadata.workspace_default_members.Count -gt 0) {
  $metadata.workspace_default_members[0]
} else {
  $metadata.packages[0].id
}
$package = $metadata.packages | Where-Object { $_.id -eq $packageId } | Select-Object -First 1

if (-not $package) {
  throw "Could not determine the Cargo package to build."
}

$binTarget = $package.targets | Where-Object { $_.kind -contains "bin" } | Select-Object -First 1
if (-not $binTarget) {
  throw "Package '$($package.name)' does not define a binary target."
}

$manifestDir = Split-Path -Parent $package.manifest_path
$tauriConfigPath = Join-Path $manifestDir "tauri.conf.json"
$tauriProductName = $null
if (Test-Path $tauriConfigPath) {
  $tauriConfig = Get-Content $tauriConfigPath -Raw | ConvertFrom-Json
  $tauriProductName = $tauriConfig.productName
}

$productName = if ($env:PORTABLE_PRODUCT_NAME) {
  $env:PORTABLE_PRODUCT_NAME
} elseif ($tauriProductName) {
  $tauriProductName
} else {
  $package.name
}

$exeName = if ($env:PORTABLE_EXE_NAME) {
  $env:PORTABLE_EXE_NAME
} else {
  "$($binTarget.name).exe"
}
if (-not $exeName.EndsWith(".exe", [StringComparison]::OrdinalIgnoreCase)) {
  $exeName = "$exeName.exe"
}

$releaseName = if ($env:PORTABLE_RELEASE_NAME) {
  $env:PORTABLE_RELEASE_NAME
} else {
  "$productName-$($package.version)-portable"
}

$localReleaseRoot = if ($env:PORTABLE_LOCAL_RELEASE_ROOT) {
  $env:PORTABLE_LOCAL_RELEASE_ROOT
} else {
  Join-Path (Get-Location).Path "release"
}
$localReleaseDir = Join-Path $localReleaseRoot $releaseName

$windowsReleaseRoot = if ($env:PORTABLE_WINDOWS_RELEASE_ROOT) {
  $env:PORTABLE_WINDOWS_RELEASE_ROOT
} elseif ($env:MYTOKEN_WINDOWS_RELEASE_ROOT) {
  $env:MYTOKEN_WINDOWS_RELEASE_ROOT
} else {
  Join-Path (Join-Path $env:USERPROFILE "Downloads") $productName
}
$windowsReleaseDir = Join-Path $windowsReleaseRoot $releaseName
$builtExe = Join-Path (Join-Path $metadata.target_directory "release") $exeName

Write-Host "Building $productName Windows portable package..."
Write-Host "Project:  $((Get-Location).Path)"
Write-Host "Manifest: $manifestPath"
Write-Host "Binary:   $exeName"
Write-Host ""

cargo build --release --manifest-path $manifestPath
if ($LASTEXITCODE -ne 0) {
  throw "cargo build failed with exit code $LASTEXITCODE."
}

if (-not (Test-Path $builtExe)) {
  throw "Expected build output was not found: $builtExe"
}

if (Test-Path $localReleaseDir) {
  Remove-Item -Recurse -Force $localReleaseDir
}

New-Item -ItemType Directory -Path $localReleaseDir | Out-Null
Copy-Item $builtExe (Join-Path $localReleaseDir $exeName) -Force

if (Test-Path $windowsReleaseDir) {
  Remove-Item -Recurse -Force $windowsReleaseDir
}

New-Item -ItemType Directory -Path $windowsReleaseRoot | Out-Null
Copy-Item $localReleaseDir $windowsReleaseRoot -Recurse -Force

Write-Host ""
Write-Host "Built in project:"
Write-Host "  $(Join-Path $localReleaseDir $exeName)"
Write-Host ""
Write-Host "Copied Windows portable artifact:"
Write-Host "  $(Join-Path $windowsReleaseDir $exeName)"
Write-Host ""
Write-Host "Set PORTABLE_WINDOWS_RELEASE_ROOT to override the Windows artifact root."
