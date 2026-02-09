# Changelog

All notable changes to PCClaw will be documented in this file.

## [1.5.0] - 2026-02-09

### Added
- `win-whisper` skill — Record audio and transcribe speech to text using Whisper, running fully local. Uses whisper.cpp v1.8.3 with OpenBLAS acceleration. Supports WAV/MP3/FLAC/OGG, auto language detection, translation to English, SRT subtitle output, Voice Activity Detection, and real-time streaming transcription. Includes zero-dependency audio recording via Windows Multimedia API (winmm.dll). Optional Intel GPU/NPU acceleration via OpenVINO.

### Changed
- Bumped version to 1.5.0

## [1.4.0] - 2026-02-09

### Added
- `win-ocr` skill — Extract text from images and screenshots using Windows built-in OCR (Windows.Media.Ocr WinRT API). Supports multilingual recognition (English, Traditional Chinese, and any installed language pack). Includes word-level bounding boxes for click targeting. Fully offline, zero external dependencies.

### Changed
- Bumped version to 1.4.0

## [1.3.0] - 2026-02-09

### Added
- `win-ui-auto` skill — Windows UI automation: inspect UI element trees, click, double-click, right-click, type text, send hotkeys, focus/move/resize/minimize/maximize/close windows, launch/quit apps, scroll. The Windows counterpart to Peekaboo (macOS). Uses .NET UI Automation + Win32 APIs with zero external dependencies.

### Changed
- Bumped version to 1.3.0

## [1.2.0] - 2026-02-09

### Added
- `win-screenshot` skill — Screen capture (full screen, region, specific window) + window listing via .NET System.Drawing (zero dependencies)
- `win-clipboard` skill — Clipboard read/write for text, images, and file lists via .NET Windows.Forms (zero dependencies)

### Changed
- Bumped version to 1.2.0

## [1.1.0] - 2026-02-09

### Added
- **Skills pack** — PCClaw is now an installer + skills bundle
- `win-notify` skill — Native Windows toast notifications via PowerShell/WinRT (zero dependencies)
- `winget` skill — Windows Package Manager integration (search, install, upgrade, export)
- `ms-todo` skill — Microsoft To Do via Graph API (cross-platform counterpart to `apple-reminders`)
- `google-tasks` skill — Google Tasks via `gog` CLI or REST API (cross-platform)
- `.gitignore` — Exclude macOS `.DS_Store` files
- `CHANGELOG.md` — This file

### Changed
- Rebranded from "OpenClaw Installer" to **PCClaw** — reflecting the expanded scope beyond just installation
- Updated README with skills documentation and PCClaw identity

## [1.0.1] - 2026-02-06

### Fixed
- PowerShell window no longer closes instantly on error or completion ([PR #1](https://github.com/IrisGoLab/pcclaw/pull/1) by @TonySincerely)
- Synced `web/i.ps1` with `quick-install.ps1` after PR merge

## [1.0.0] - 2026-02-04

### Added
- Initial release
- One-command Windows installer (`irm openclaw.irisgo.xyz/i | iex`)
- Interactive provider selection (Anthropic, OpenAI, Gemini, GLM, OpenAI-compatible)
- Automatic prerequisites installation (Node.js, Git via winget)
- OpenClaw installation and LLM configuration
- Moltbook agent registration and first post
- Landing page at `openclaw.irisgo.xyz`
- BYOK (Bring Your Own Key) — API keys stay local
