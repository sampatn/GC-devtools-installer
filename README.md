# Azure Agent Dev Tools Installer

> One-click setup for the Global Skilling team to build AI agents on Azure AI Foundry, Copilot Studio, and Teams.

## Quick Start (2 steps)

### Step 1: Install Agency (GitHub Copilot CLI)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/sampatn/GC-devtools-installer/main/install-agent-devtools.ps1 | iex
```

Or if you have the file locally:

```powershell
.\install-agent-devtools.ps1
```

> **Note:** Close and reopen your terminal after this step.

### Step 2: Let Copilot install everything else

Open a **new terminal** and start a Copilot CLI session:

```powershell
agency copilot
```

Then paste this prompt (it was copied to your clipboard by Step 1):

> *"Install my agent dev tools. I want tracks 1, 2, and 3."*

Or just say which tracks you need:
- **Track 1** — Azure AI Foundry (code-first agents)
- **Track 2** — Power Platform / Copilot Studio (low-code)
- **Track 3** — Teams / M365 Copilot (ATK)

Copilot will install all the tools, extensions, and SDKs for your selected tracks.

## What gets installed

### Core Tools (everyone)
| Tool | Purpose |
|------|---------|
| Git | Source control |
| Node.js + npm | JavaScript runtime & packages |
| Python 3.12 | Python runtime & pip |
| .NET 8 SDK | C# / Power Platform development |
| Azure CLI | Azure resource management |
| Azure Developer CLI (azd) | Project scaffolding & deployment |
| Docker Desktop | Container-based agent testing |
| GitHub CLI (gh) | Repo & PR management |
| Agency (Copilot CLI) | AI-powered terminal assistant |

### Track-Specific
| Track | Additional Tools |
|-------|-----------------|
| Azure AI Foundry | azure-ai-projects (pip), AI Toolkit (Windows AI Studio) VS Code ext |
| Power Platform | pac CLI, Power Platform VS Code ext |
| Teams / M365 | ATK CLI, Teams Toolkit VS Code ext |

### VS Code Extensions (shared)
GitHub Copilot, Copilot Chat, Python, C# Dev Kit, Azure Functions, Azure RM

## Authentication

### GitHub Copilot Login (first time)

After starting `agency copilot`, you'll be prompted to log in if not already authenticated:

1. Run the `/login` slash command in the Copilot interface
2. Select **GitHub.com**
3. Use your **GitHub EMU account**: `alias_microsoft` (e.g., `jdoe_microsoft`)
4. Follow the link and enter the code shown in terminal

> Your session persists across terminal restarts once authenticated.

### Other auth (after tool install)

```powershell
az login           # Azure
gh auth login      # GitHub CLI
pac auth create    # Power Platform (Track 2 only)
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `agency` not found after install | Close and reopen terminal (PATH refresh) |
| Copilot login fails | Use your EMU account (`alias_microsoft`) |
| Can't authenticate | Try `/logout` then `/login` to refresh |
| winget not available | Update "App Installer" from Microsoft Store |
| Docker needs restart | Reboot after Docker Desktop install |
| pip not found | Run `python -m pip` instead |
| No GitHub Copilot access | Verify access via your Microsoft org settings |

## Files in this repo

| File | Purpose |
|------|---------|
| `install-agent-devtools.ps1` | Bootstrap script (installs Agency) |
| `copilot-setup-prompt.md` | Instructions Copilot CLI uses to install remaining tools |
| `README.md` | This file |

## Links
- [Agency (Copilot CLI) Docs](https://aka.ms/agency)
- [Azure AI Foundry](https://learn.microsoft.com/azure/ai-foundry/)
- [Power Platform CLI](https://learn.microsoft.com/power-platform/developer/cli/introduction)
- [Agents Toolkit](https://learn.microsoft.com/microsoftteams/platform/toolkit/teams-toolkit-fundamentals)

---

## Support

Personal tool maintained by **Vinay Sampatn** for Global Skilling / AI Task Force.
Not an official Microsoft release. Issues or suggestions: [open an issue](https://github.com/sampatn/GC-devtools-installer/issues).
