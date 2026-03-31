param(
    [switch]$SkipAnalyze,
    [switch]$SkipTest,
    [switch]$GeneratePlatforms,
    [string]$Platforms = 'android,web'
)

$ErrorActionPreference = 'Stop'

function Invoke-Step {
    param(
        [string]$Name,
        [scriptblock]$Action
    )

    Write-Host "`n==> $Name" -ForegroundColor Cyan
    & $Action
}

try {
    Invoke-Step -Name 'Check Flutter CLI' -Action {
        if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
            throw 'flutter command not found. Install Flutter and add it to PATH.'
        }
        flutter --version
    }

    Invoke-Step -Name 'Fetch dependencies (flutter pub get)' -Action {
        flutter pub get
    }

    if ($GeneratePlatforms) {
        Invoke-Step -Name "Generate platform folders (flutter create . --platforms=$Platforms)" -Action {
            flutter create . --platforms=$Platforms
        }
        Invoke-Step -Name 'Fetch dependencies again (flutter pub get)' -Action {
            flutter pub get
        }
    }

    if (-not $SkipAnalyze) {
        Invoke-Step -Name 'Static analysis (flutter analyze)' -Action {
            flutter analyze --no-fatal-infos
        }
    }

    if (-not $SkipTest) {
        Invoke-Step -Name 'Run tests (flutter test)' -Action {
            flutter test
        }
    }

    Write-Host "`nDone: bootstrap checks passed." -ForegroundColor Green
} catch {
    Write-Host "`nFailed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
