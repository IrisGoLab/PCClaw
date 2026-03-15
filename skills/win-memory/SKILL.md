---
name: win-memory
description: Persistent agent memory via OpenViking — store and retrieve context across sessions using a tiered filesystem database. L0/L1/L2 context layers with semantic search.
metadata:
  {
    "openclaw":
      {
        "emoji": "🧬",
        "os": ["win32"],
        "requires": { "bins": ["python", "openviking-server"] },
        "install": "pip install openviking",
      },
  }
---

# win-memory

Persistent agent memory for OpenClaw on Windows, powered by [OpenViking](https://github.com/volcengine/OpenViking) — an open-source context database designed for AI agents.

OpenViking stores memories, resources, and skills in a virtual filesystem (`viking://`) with three context tiers:
- **L0** (Abstract, ~100 tokens) — quick relevance check
- **L1** (Overview, ~2k tokens) — key information for planning
- **L2** (Full content) — loaded on demand only

This means your agent loads context efficiently, not all at once.

## Setup

### 1. Install OpenViking

```powershell
winget install Python.Python.3.12
pip install openviking
```

### 2. Configure

```powershell
$configDir = "$env:USERPROFILE\.openviking"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

# Minimal config using local Ollama (no API cost)
$config = @{
    storage = @{ workspace = "$env:USERPROFILE\.openviking\workspace" }
    log = @{ level = "INFO"; output = "stdout" }
    embedding = @{
        dense = @{
            api_base = "http://localhost:11434/v1"
            api_key = "ollama"
            provider = "openai"
            dimension = 768
            model = "nomic-embed-text"
        }
    }
    vlm = @{
        api_base = "http://localhost:11434/v1"
        api_key = "ollama"
        provider = "openai"
        model = "llama3.1"
    }
} | ConvertTo-Json -Depth 5
$config | Out-File -Encoding utf8 "$configDir\ov.conf"

Write-Host "OpenViking configured at $configDir\ov.conf"
```

### 3. Start the Server

```powershell
# Start in background (port 1933 by default)
Start-Process -WindowStyle Hidden -FilePath "openviking-server" -ArgumentList "--with-bot"
Write-Host "OpenViking server started at http://localhost:1933"
```

### 4. Register as Startup Task (Optional)

```powershell
$action = New-ScheduledTaskAction -Execute "openviking-server" -Argument "--with-bot"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Limited
Register-ScheduledTask -TaskName "OpenViking Memory Server" -Action $action -Trigger $trigger -Principal $principal -Force
Write-Host "OpenViking will auto-start on login"
```

## Memory Operations

### Store a Memory

```powershell
# Store text memory
ov add-resource "I prefer concise email replies. No fluff." --uri "viking://user/memories/preferences/email-style"

# Store a file or folder
ov add-resource "C:\Users\$env:USERNAME\Documents\project-notes" --uri "viking://user/memories/work/project"

# Store a web page
ov add-resource "https://docs.example.com/api" --uri "viking://resources/docs/api"
```

### Recall / Search

```powershell
# Semantic search across all memories
ov find "how do I write emails"

# Search within a specific namespace
ov find "project deadline" --uri "viking://user/memories/work"

# Browse the memory tree
ov tree viking://user -L 2
ov ls viking://user/memories/
```

### Session Memory (Auto-extract)

At the end of a session, OpenViking can automatically extract long-term memories:

```powershell
# Extract memories from current session (runs async)
ov session extract
```

### Check Status

```powershell
# Check server health
ov status

# List all stored resources
ov ls viking://

# Show full tree
ov tree viking:// -L 3
```

## Memory Structure

```
viking://
├── user/
│   └── memories/
│       ├── preferences/      # Work style, communication prefs
│       ├── work/             # Project notes, task context
│       └── contacts/         # People and relationships
├── agent/
│   ├── memories/             # Agent task experience
│   ├── skills/               # Learned skill patterns
│   └── instructions/         # Persistent agent rules
└── resources/                # External docs, web pages, files
```

## Why OpenViking?

| | Traditional RAG | OpenViking |
|---|---|---|
| Storage | Flat vector chunks | Hierarchical filesystem |
| Loading | All-or-nothing | L0/L1/L2 tiered (91% fewer tokens) |
| Retrieval | Single-pass embedding | Directory-recursive + semantic |
| Debugging | Black box | Visualized retrieval trajectory |
| Memory growth | Manual | Auto-extract from sessions |

**Benchmark**: OpenClaw + OpenViking = **52% task completion** vs 35% baseline.
Token usage: **91% reduction** compared to flat RAG.
Source: [OpenViking LoCoMo10 evaluation](https://github.com/volcengine/OpenViking)

## Troubleshooting

**Server not starting**: Make sure Python 3.10+ is installed.
```powershell
python --version
pip install openviking --upgrade
```

**Embedding model not found (Ollama)**:
```powershell
ollama pull nomic-embed-text
```

**Port conflict**: Change port in ov.conf `"port": 1934` and set env `OPENVIKING_PORT=1934`.

## Links

- [OpenViking GitHub](https://github.com/volcengine/OpenViking)
- [OpenViking Docs](https://openviking.io/docs)
- [OpenClaw Memory Plugin](https://github.com/volcengine/OpenViking/blob/main/plugins/openclaw/README.md)
