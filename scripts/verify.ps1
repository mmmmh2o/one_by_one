param(
    [switch]$BuildAndroid
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
    }

    Invoke-Step -Name 'Static analysis (flutter analyze)' -Action {
        flutter analyze --no-fatal-infos
    }

    Invoke-Step -Name 'Run tests (flutter test)' -Action {
        flutter test
    }

    if ($BuildAndroid) {
        Invoke-Step -Name 'Check android directory' -Action {
            if (-not (Test-Path -Path 'android')) {
                throw 'android/ directory not found. Run ./scripts/bootstrap.ps1 -GeneratePlatforms first.'
            }
        }

        Invoke-Step -Name 'Build Android debug APK (flutter build apk --debug)' -Action {
            flutter build apk --debug
        }
    }

    Write-Host "`nDone: verification checks passed." -ForegroundColor Green
} catch {
    Write-Host "`nFailed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
