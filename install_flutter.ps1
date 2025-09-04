# Gyan AI Flutter Installation Script
# Run this script as Administrator in PowerShell

Write-Host "🚀 Gyan AI Flutter Installation Script" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Check if running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Please run this script as Administrator" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit
}

# Step 1: Download Flutter SDK
Write-Host "`n📥 Step 1: Downloading Flutter SDK..." -ForegroundColor Blue
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip"
$flutterZip = "$env:TEMP\flutter_windows_stable.zip"

try {
    Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -UseBasicParsing
    Write-Host "✅ Flutter SDK downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download Flutter SDK: $_" -ForegroundColor Red
    Write-Host "Please download manually from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Yellow
    pause
    exit
}

# Step 2: Extract Flutter
Write-Host "`n📦 Step 2: Extracting Flutter SDK to C:\flutter..." -ForegroundColor Blue
try {
    if (Test-Path "C:\flutter") {
        Remove-Item "C:\flutter" -Recurse -Force
    }
    
    Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force
    Write-Host "✅ Flutter SDK extracted successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to extract Flutter SDK: $_" -ForegroundColor Red
    pause
    exit
}

# Step 3: Add to PATH
Write-Host "`n🔧 Step 3: Adding Flutter to PATH..." -ForegroundColor Blue
try {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($currentPath -notlike "*C:\flutter\bin*") {
        $newPath = $currentPath + ";C:\flutter\bin"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Write-Host "✅ Flutter added to system PATH" -ForegroundColor Green
    } else {
        Write-Host "✅ Flutter already in PATH" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Failed to add Flutter to PATH: $_" -ForegroundColor Red
}

# Step 4: Install Git (if not present)
Write-Host "`n🔧 Step 4: Checking Git installation..." -ForegroundColor Blue
try {
    git --version | Out-Null
    Write-Host "✅ Git is already installed" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Git not found. Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    Start-Process "https://git-scm.com/download/win"
}

# Step 5: Clean up
Write-Host "`n🧹 Step 5: Cleaning up..." -ForegroundColor Blue
Remove-Item $flutterZip -Force
Write-Host "✅ Cleanup completed" -ForegroundColor Green

# Step 6: Next steps
Write-Host "`n🎉 Flutter SDK Installation Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "📋 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Close this PowerShell window"
Write-Host "2. Open a NEW PowerShell window (to reload PATH)"
Write-Host "3. Run: flutter doctor"
Write-Host "4. Install Android Studio from: https://developer.android.com/studio"
Write-Host "5. Run: flutter doctor --android-licenses"
Write-Host ""
Write-Host "🎯 Then navigate to your project and run:"
Write-Host "   cd C:\Users\dhrit\Desktop\Gyan-Ai\frontend"
Write-Host "   flutter pub get"
Write-Host "   flutter run"
Write-Host ""

pause
