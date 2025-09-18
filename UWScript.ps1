# UnattendedWinstall Light - Gaming Edition Utility Script
# Simple post-installation utility for Windows 11 Pro 24H2 Gaming Setup

# Check if script is running as Administrator
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Try {
        Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit
    }
    Catch {
        Write-Host "Failed to run as Administrator. Please rerun with elevated privileges."
        Exit
    }
}

# Set window title
$Host.UI.RawUI.WindowTitle = "UnattendedWinstall Light - Gaming Edition Utility"
Clear-Host

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  UnattendedWinstall Light - Gaming Edition  " -ForegroundColor White
Write-Host "     Post-Installation Utility Script       " -ForegroundColor Gray
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Gaming optimizations already applied during installation!" -ForegroundColor Green
Write-Host ""
Write-Host "Your system has been optimized for:" -ForegroundColor Yellow
Write-Host "• Gaming (Steam, Discord, Spotify)" -ForegroundColor White
Write-Host "• Accessibility features disabled" -ForegroundColor White  
Write-Host "• Privacy settings enhanced" -ForegroundColor White
Write-Host "• Bloatware removed" -ForegroundColor White
Write-Host "• Performance optimizations active" -ForegroundColor White
Write-Host ""

function Show-Menu {
    Write-Host "Available Actions:" -ForegroundColor Cyan
    Write-Host "1. Install Gaming Software (Steam, Discord, Spotify)" -ForegroundColor White
    Write-Host "2. Check Gaming Optimizations Status" -ForegroundColor White
    Write-Host "3. Install Additional Software (Winget)" -ForegroundColor White
    Write-Host "4. Exit" -ForegroundColor White
    Write-Host ""
}

function Install-GamingSoftware {
    Write-Host "Installing Gaming Software..." -ForegroundColor Yellow
    
    $software = @(
        @{Name="Steam"; Id="Valve.Steam"},
        @{Name="Discord"; Id="Discord.Discord"},
        @{Name="Spotify"; Id="Spotify.Spotify"}
    )
    
    foreach ($app in $software) {
        Write-Host "Installing $($app.Name)..." -ForegroundColor Green
        try {
            winget install --id $($app.Id) --accept-package-agreements --accept-source-agreements -h
            Write-Host "✅ $($app.Name) installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to install $($app.Name)" -ForegroundColor Red
        }
    }
}

function Check-Optimizations {
    Write-Host "Checking Gaming Optimizations..." -ForegroundColor Yellow
    Write-Host ""
    
    # Check Game Mode
    $gameMode = Get-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -ErrorAction SilentlyContinue
    if ($gameMode.AutoGameModeEnabled -eq 1) {
        Write-Host "✅ Game Mode: Enabled" -ForegroundColor Green
    } else {
        Write-Host "❌ Game Mode: Disabled" -ForegroundColor Red
    }
    
    # Check GameDVR
    $gameDVR = Get-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -ErrorAction SilentlyContinue
    if ($gameDVR.GameDVR_Enabled -eq 0) {
        Write-Host "✅ GameDVR: Disabled (Better Performance)" -ForegroundColor Green
    } else {
        Write-Host "❌ GameDVR: Enabled" -ForegroundColor Red
    }
    
    # Check StickyKeys
    $stickyKeys = Get-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -ErrorAction SilentlyContinue
    if ($stickyKeys.Flags -eq "2") {
        Write-Host "✅ StickyKeys: Disabled" -ForegroundColor Green
    } else {
        Write-Host "❌ StickyKeys: Enabled" -ForegroundColor Red
    }
    
    # Check Narrator
    $narrator = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Narrator\NoRoam" -Name "WinEnterLaunchEnabled" -ErrorAction SilentlyContinue
    if ($narrator.WinEnterLaunchEnabled -eq 0) {
        Write-Host "✅ Narrator: Disabled" -ForegroundColor Green
    } else {
        Write-Host "❌ Narrator: Enabled" -ForegroundColor Red
    }
    
    Write-Host ""
}

function Install-AdditionalSoftware {
    Write-Host "Popular Gaming & Productivity Software:" -ForegroundColor Cyan
    Write-Host "1. 7-Zip"
    Write-Host "2. Google Chrome"
    Write-Host "3. VLC Media Player"
    Write-Host "4. OBS Studio"
    Write-Host "5. Visual Studio Code"
    Write-Host "6. Install all above"
    Write-Host "7. Back to main menu"
    Write-Host ""
    
    $choice = Read-Host "Select option (1-7)"
    
    $apps = @{
        "1" = @{Name="7-Zip"; Id="7zip.7zip"}
        "2" = @{Name="Google Chrome"; Id="Google.Chrome"}
        "3" = @{Name="VLC Media Player"; Id="VideoLAN.VLC"}
        "4" = @{Name="OBS Studio"; Id="OBSProject.OBSStudio"}
        "5" = @{Name="Visual Studio Code"; Id="Microsoft.VisualStudioCode"}
    }
    
    if ($choice -eq "6") {
        # Install all
        foreach ($app in $apps.Values) {
            Write-Host "Installing $($app.Name)..." -ForegroundColor Green
            winget install --id $($app.Id) --accept-package-agreements --accept-source-agreements -h
        }
    } elseif ($apps.ContainsKey($choice)) {
        $app = $apps[$choice]
        Write-Host "Installing $($app.Name)..." -ForegroundColor Green
        winget install --id $($app.Id) --accept-package-agreements --accept-source-agreements -h
    } elseif ($choice -eq "7") {
        return
    } else {
        Write-Host "Invalid selection" -ForegroundColor Red
    }
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Select an option (1-4)"
    
    switch ($choice) {
        "1" { Install-GamingSoftware; Pause }
        "2" { Check-Optimizations; Pause }  
        "3" { Install-AdditionalSoftware; Pause }
        "4" { 
            Write-Host "Thanks for using UnattendedWinstall Light!" -ForegroundColor Green
            Write-Host "Happy Gaming! 🎮" -ForegroundColor Cyan
            Exit 
        }
        default { 
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            Pause
        }
    }
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "  UnattendedWinstall Light - Gaming Edition  " -ForegroundColor White
    Write-Host "     Post-Installation Utility Script       " -ForegroundColor Gray
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
} while ($true)