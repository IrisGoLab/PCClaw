# PCClaw — OpenClaw for Windows

> The missing Windows experience for [OpenClaw](https://openclaw.ai). Installer + Skills pack.

**v1.5.0** | Powered by [IrisGo.AI](https://irisgo.ai)

---

## What is PCClaw?

[OpenClaw](https://openclaw.ai) is a great AI agent framework, but its skill ecosystem is heavily macOS-focused (Apple Notes, Reminders, Peekaboo, Things, iMessage...). **PCClaw** fills the gap for Windows users:

1. **One-command installer** — Get OpenClaw + Moltbook running on Windows in 2 minutes
2. **Windows-native skills** — Toast notifications, winget package management
3. **Cross-platform task management** — Microsoft To Do + Google Tasks (the mobile task app duo)

```
OpenClaw Skills Ecosystem:
  macOS:   apple-notes, apple-reminders, peekaboo, things-mac, imsg, bear-notes
  Windows: win-notify, winget, win-screenshot, win-clipboard,       ← PCClaw
           win-ui-auto, win-ocr, win-whisper                       ← PCClaw
  Cross:   ms-todo, google-tasks                                   ← PCClaw
```

---

## Quick Start (Windows)

### Option 1: Interactive (Recommended)

```powershell
irm openclaw.irisgo.xyz/i | iex
```

This will prompt you to:
1. Select your LLM provider
2. Enter your API key
3. Choose an agent name

### Option 2: One-liner with Parameters

```powershell
# Anthropic
.\install.ps1 -ApiKey "sk-ant-your-key" -AgentName "my_agent"

# OpenAI
.\install.ps1 -ApiKey "sk-your-key" -AgentName "my_agent" -Provider "openai"

# GLM (Zhipu AI)
.\install.ps1 -ApiKey "your-glm-key" -AgentName "my_agent" -Provider "glm"

# Local LLM (Ollama, LM Studio, etc.)
.\install.ps1 -ApiKey "any" -AgentName "my_agent" -Provider "openai-compatible" -BaseUrl "http://localhost:11434/v1"
```

## Supported Providers

| Provider | Description |
|----------|-------------|
| Anthropic | Claude models (default) |
| OpenAI | GPT models |
| Google Gemini | Gemini models |
| GLM | Zhipu AI models |
| OpenAI Compatible | Ollama, LM Studio, vLLM, etc. |

---

## Skills Pack

PCClaw includes community-contributed OpenClaw skills that work out of the box on Windows.

### Windows-Only Skills

| Skill | Description | Dependencies |
|-------|-------------|--------------|
| [`win-notify`](skills/win-notify/SKILL.md) | Native Windows toast notifications via WinRT API | None (built-in PowerShell) |
| [`winget`](skills/winget/SKILL.md) | Windows Package Manager — search, install, upgrade software | winget (pre-installed on Win 10/11) |
| [`win-screenshot`](skills/win-screenshot/SKILL.md) | Screen capture (full, region, or window) + window listing | None (built-in .NET) |
| [`win-clipboard`](skills/win-clipboard/SKILL.md) | Clipboard read/write — text, images, file lists | None (built-in .NET) |
| [`win-ui-auto`](skills/win-ui-auto/SKILL.md) | UI automation — inspect elements, click, type, manage windows | None (built-in .NET + Win32) |
| [`win-ocr`](skills/win-ocr/SKILL.md) | Extract text from images/screenshots — multilingual, offline | None (built-in Windows OCR) |
| [`win-whisper`](skills/win-whisper/SKILL.md) | Speech-to-text using Whisper — local, GPU/NPU accelerated | whisper.cpp (one-time download) |

### Cross-Platform Skills (Task Management)

| Skill | Description | Counterpart |
|-------|-------------|-------------|
| [`ms-todo`](skills/ms-todo/SKILL.md) | Microsoft To Do via Graph API | `apple-reminders` |
| [`google-tasks`](skills/google-tasks/SKILL.md) | Google Tasks via `gog` CLI or REST API | `apple-reminders` |

### Install Skills

```powershell
# Copy all PCClaw skills to your OpenClaw
Copy-Item -Recurse .\skills\* "$env:USERPROFILE\.openclaw\skills\"
```

Skills are loaded automatically on the next OpenClaw session.

---

## What the Installer Does

1. **Checks prerequisites** — Installs Node.js and Git if needed (via winget)
2. **Installs OpenClaw** — `npm install -g openclaw@latest`
3. **Configures your LLM** — Sets up API key for your chosen provider
4. **Registers on Moltbook** — Creates your AI agent profile
5. **Posts first message** — Your agent introduces itself!
6. **Launches onboard wizard** — Gets you started immediately

## Requirements

- Windows 10/11 (PowerShell 5.1+)
- Internet connection
- LLM API key (any supported provider)

## BYOK — Bring Your Own Key

This installer does NOT store or transmit your API key to any server other than:
- OpenClaw (local configuration)
- Your chosen LLM provider

Your API key stays on your machine.

---

## After Installation

1. **Claim your agent** — Visit the claim URL shown after installation
2. **Run OpenClaw** — Just type `openclaw` in terminal
3. **Install PCClaw skills** — Copy skills to `~/.openclaw/skills/`
4. **Share your profile** — Show off on social media!

## Troubleshooting

### "Node.js not found after installation"
Close your terminal and open a new one, then run the installer again.

### "winget not available"
Install Node.js manually from https://nodejs.org, then run the installer again.

### "Moltbook registration failed"
- Your agent name might be taken — try a different name
- Moltbook API might be temporarily down — try again later

### "OpenClaw won't start"
Make sure your API key is valid and has sufficient credits.

## Files Created

```
%USERPROFILE%\
├── .openclaw\
│   ├── config.json     # OpenClaw configuration
│   └── skills\         # PCClaw skills (after install)
└── .config\
    └── moltbook\
        └── credentials.json
```

## Uninstall

```powershell
npm uninstall -g openclaw
Remove-Item -Recurse "$env:USERPROFILE\.openclaw"
Remove-Item -Recurse "$env:USERPROFILE\.config\moltbook"
```

---

## Contributing

We welcome new Windows skills! See [CHANGELOG.md](CHANGELOG.md) for version history.

To create a new skill:
1. Create a folder under `skills/<skill-name>/`
2. Add a `SKILL.md` following [OpenClaw's skill format](https://openclaw.ai)
3. Test locally by copying to `~/.openclaw/skills/`
4. Open a PR

## Links

- [OpenClaw Official](https://openclaw.ai)
- [Moltbook](https://moltbook.com)
- [IrisGo.AI](https://irisgo.ai)
- [IrisGo Community Slack](https://join.slack.com/t/irisgo-community/shared_invite/zt-3i3qm7sds-A4WIKXk4rQHgG1FUg1i0Og)

## License

MIT License — Use at your own risk.

---

*PCClaw is a community project by [IrisGo.AI](https://irisgo.ai) and is not officially affiliated with OpenClaw.*
