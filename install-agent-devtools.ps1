#Requires -Version 5.1
<#
.SYNOPSIS
    Azure Agent Dev Tools — Bootstrap Installer
    For: Global Skilling / AI Task Force

.DESCRIPTION
    Phase 1 bootstrap: Installs Agency (GitHub Copilot CLI — Microsoft internal build).
    After install, the user starts a Copilot CLI session which drives the remaining
    tool installations interactively.

    Two-phase approach:
      Phase 1 (this script): Install Agency → restart terminal
      Phase 2 (Copilot-driven): Run 'agency copilot' → Copilot installs remaining tools

.NOTES
    Prerequisites: Windows 10/11 with winget (App Installer) available.
    Safe to re-run — skips if Agency is already installed.

.LINK
    https://aka.ms/agency
#>

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# ============================================================
# HELPER FUNCTIONS
# ============================================================

function Write-Banner {
    param([string]$Text)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Text)
    Write-Host "  [$([char]0x2192)] $Text" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Text)
    Write-Host "  [✓] $Text" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Text)
    Write-Host "  [!] $Text" -ForegroundColor DarkYellow
}

function Write-Fail {
    param([string]$Text)
    Write-Host "  [✗] $Text" -ForegroundColor Red
}

function Refresh-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# ============================================================
# MAIN
# ============================================================

Write-Banner "Azure Agent Dev Tools — Bootstrap"
Write-Host "  For: Global Skilling / AI Task Force" -ForegroundColor White
Write-Host "  Docs: https://aka.ms/agency" -ForegroundColor DarkGray
Write-Host ""

# --- Step 1: Check if Agency is already installed ---
Refresh-Path
$agencyInstalled = Get-Command agency -ErrorAction SilentlyContinue

if ($agencyInstalled) {
    Write-Success "Agency (GitHub Copilot CLI) is already installed."
    Write-Host ""
    Write-Host "  Version: $(agency --version 2>$null)" -ForegroundColor Gray
} else {
    # --- Step 2: Install Agency ---
    Write-Step "Installing Agency (GitHub Copilot CLI — Microsoft internal)..."
    Write-Host "  Source: https://aka.ms/agency" -ForegroundColor Gray
    Write-Host ""

    try {
        iex "& { $(irm aka.ms/InstallTool.ps1)} agency"
        Refresh-Path

        if (Get-Command agency -ErrorAction SilentlyContinue) {
            Write-Success "Agency installed successfully!"
        } else {
            Write-Warn "Agency was downloaded but 'agency' is not yet on PATH."
            Write-Host "  This is normal — you need to restart your terminal." -ForegroundColor Gray
        }
    } catch {
        Write-Fail "Failed to install Agency: $_"
        Write-Host ""
        Write-Host "  Try manually:" -ForegroundColor White
        Write-Host '  iex "& { $(irm aka.ms/InstallTool.ps1)} agency"' -ForegroundColor Gray
        Write-Host ""
        exit 1
    }
}

# --- Step 3: Copy the Copilot prompt to clipboard ---
$copilotPrompt = @"
I need you to install developer tools on my Windows machine for building AI agents. Use winget for installations (silent mode). Check if each tool exists before installing. Here are the tracks — ask me which ones I want:

Track 1 - Azure AI Foundry (code-first agents)
Track 2 - Power Platform / Copilot Studio (low-code agents)
Track 3 - Teams / M365 Copilot (ATK-based agents)

CORE TOOLS (always install):
- Git (winget: Git.Git)
- Node.js LTS (winget: OpenJS.NodeJS.LTS)
- Python 3.12 (winget: Python.Python.3.12)
- .NET 8 SDK (winget: Microsoft.DotNet.SDK.8)
- Azure CLI (winget: Microsoft.AzureCLI)
- Azure Developer CLI azd (winget: Microsoft.Azd)
- Docker Desktop (winget: Docker.DockerDesktop)
- GitHub CLI (winget: GitHub.cli)

TRACK 1 TOOLS (Azure AI Foundry):
- pip install azure-ai-projects azure-identity azure-ai-inference
- VS Code extension: ms-windows-ai-studio.windows-ai-studio

TRACK 2 TOOLS (Power Platform):
- dotnet tool install -g Microsoft.PowerApps.CLI.Tool
- VS Code extension: microsoft-IsvExpTools.powerplatform-vscode

TRACK 3 TOOLS (Teams/M365 ATK):
- npm install -g @microsoft/m365agentstoolkit-cli
- VS Code extension: TeamsDevApp.ms-teams-vscode-extension

SHARED VS CODE EXTENSIONS (always):
- GitHub.copilot, GitHub.copilot-chat, ms-python.python, ms-dotnettools.csdevkit, ms-azuretools.vscode-azurefunctions, msazurermtools.azurerm-vscode-tools

After installing everything, print a version table and tell me what auth commands to run (in 'agency copilot' use /login slash command for Copilot CLI auth, then az login, gh auth login, pac auth create if Track 2).

Start by asking me which tracks I want, then proceed with installation.
"@

try {
    Set-Clipboard -Value $copilotPrompt
    $clipboardSet = $true
} catch {
    $clipboardSet = $false
}

# Always save the prompt to a known local path as a clipboard-loss fallback.
# (Clipboards get clobbered by GitHub /login auth-code copy, terminal restart, etc.)
$promptFile = Join-Path $env:USERPROFILE "copilot-setup-prompt.md"
try {
    Set-Content -Path $promptFile -Value $copilotPrompt -Encoding UTF8 -ErrorAction Stop
    $promptFileSaved = $true
} catch {
    $promptFileSaved = $false
}

# --- Step 4: Print next steps ---
Write-Host ""
Write-Banner "Next Steps"

Write-Host "  1. CLOSE this terminal and open a NEW one" -ForegroundColor White
Write-Host "     (Required for PATH to update)" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Start a Copilot CLI session (lowercase matters):" -ForegroundColor White
Write-Host ""
Write-Host "     agency copilot" -ForegroundColor Green
Write-Host ""
Write-Host "  3. Authenticate with GitHub (if prompted):" -ForegroundColor White
Write-Host "     - Run the /login slash command" -ForegroundColor Gray
Write-Host "     - Select GitHub.com" -ForegroundColor Gray
Write-Host "     - Use your EMU account: alias_microsoft (e.g., jdoe_microsoft)" -ForegroundColor Gray
Write-Host "     - Follow the link and enter the code shown in terminal" -ForegroundColor Gray
Write-Host ""
Write-Host "  4. Paste the setup prompt to have Copilot install your tools:" -ForegroundColor White

if ($clipboardSet) {
    Write-Host ""
    Write-Host "     ✓ Prompt is on your clipboard — Ctrl+V into the Copilot session." -ForegroundColor Green
}

if ($promptFileSaved) {
    Write-Host ""
    Write-Host "     If the clipboard was lost (e.g., after copying the GitHub auth code)," -ForegroundColor Gray
    Write-Host "     the prompt is also saved here:" -ForegroundColor Gray
    Write-Host "     $promptFile" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "     Reload it onto the clipboard any time with:" -ForegroundColor Gray
    Write-Host "     Get-Content `"$promptFile`" -Raw | Set-Clipboard" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "     Fallback: grab the prompt from GitHub:" -ForegroundColor Gray
    Write-Host "     https://github.com/sampatn/GC-devtools-installer/blob/main/copilot-setup-prompt.md" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  ─────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Alternatively, if you have copilot-instructions.md in your" -ForegroundColor Gray
Write-Host "  project's .github/ folder, Copilot will auto-load the setup." -ForegroundColor Gray
Write-Host "  ─────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅ Bootstrap Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

