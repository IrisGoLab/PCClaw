<#
.SYNOPSIS
    Quick installer wrapper - downloads and runs the full installer
    Usage: iwr -useb "openclaw.irisgo.xyz/install.ps1" | iex

.DESCRIPTION
    This is the entry point script that:
    1. Prompts for provider selection
    2. Prompts for API key if not provided via URL params
    3. Downloads the full installer
    4. Executes it with the provided parameters
#>

param(
    [string]$k = "",      # API Key (short param for URL)
    [string]$n = "",      # Agent Name (short param for URL)
    [string]$p = ""       # Provider
)

$ErrorActionPreference = "Stop"

try {

Write-Host @"

  ====================================================
       PCClaw - OpenClaw for Windows  v1.1.0
              Powered by IrisGo.AI
  ====================================================

"@ -ForegroundColor Cyan

# Decode base64 if needed (for URL-safe transmission)
function Decode-Base64 {
    param([string]$encoded)
    if ($encoded -match '^[A-Za-z0-9+/=]+$' -and $encoded.Length -gt 20) {
        try {
            return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encoded))
        } catch {}
    }
    return $encoded
}

# Provider selection
$providers = @{
    "1" = @{ name = "anthropic"; display = "Anthropic (Claude)"; url = "https://console.anthropic.com" }
    "2" = @{ name = "openai"; display = "OpenAI (GPT)"; url = "https://platform.openai.com" }
    "3" = @{ name = "gemini"; display = "Google Gemini"; url = "https://aistudio.google.com" }
    "4" = @{ name = "glm"; display = "GLM (Zhipu AI)"; url = "https://open.bigmodel.cn" }
    "5" = @{ name = "openai-compatible"; display = "OpenAI Compatible (custom endpoint)"; url = "" }
}

$Provider = $p
if ([string]::IsNullOrWhiteSpace($Provider)) {
    Write-Host "  Select your LLM provider:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    [1] Anthropic (Claude)" -ForegroundColor Cyan
    Write-Host "    [2] OpenAI (GPT)"
    Write-Host "    [3] Google Gemini"
    Write-Host "    [4] GLM (Zhipu AI)"
    Write-Host "    [5] OpenAI Compatible (Ollama, LM Studio, etc.)"
    Write-Host ""
    $choice = Read-Host "  Enter choice (1-5)"

    if ($providers.ContainsKey($choice)) {
        $Provider = $providers[$choice].name
        $providerUrl = $providers[$choice].url
    } else {
        $choice = "1"
        $Provider = "anthropic"
        $providerUrl = $providers["1"].url
    }
    Write-Host ""
    Write-Host "  Selected: $($providers[$choice].display)" -ForegroundColor Green
}

# Get API Key
$ApiKey = Decode-Base64 $k

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    Write-Host ""
    Write-Host "  Enter your API key" -ForegroundColor Yellow
    if ($providerUrl) {
        Write-Host "  (Get one at $providerUrl)"
    }
    Write-Host ""
    $ApiKey = Read-Host "  API Key"

    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        Write-Host "`n  Error: API key is required" -ForegroundColor Red
        throw "API key is required."
    }
}

# Get custom endpoint for OpenAI-compatible
$BaseUrl = ""
if ($Provider -eq "openai-compatible") {
    Write-Host ""
    Write-Host "  Enter your API base URL" -ForegroundColor Yellow
    Write-Host "  (e.g., http://localhost:11434/v1 for Ollama)"
    $BaseUrl = Read-Host "  Base URL"
}

# Get Agent Name
$AgentName = $n
if ([string]::IsNullOrWhiteSpace($AgentName)) {
    Write-Host ""
    Write-Host "  Enter a name for your AI agent (or press Enter for random)" -ForegroundColor Yellow
    Write-Host "  (lowercase, letters and underscores only)"
    $AgentName = Read-Host "  Agent name"
}

# Auto-detect provider from key format if not already set
if ([string]::IsNullOrWhiteSpace($p)) {
    if ($ApiKey -match '^sk-ant-') {
        $Provider = "anthropic"
    } elseif ($ApiKey -match '^sk-') {
        # Could be OpenAI or compatible, keep user selection
    }
}

Write-Host ""
Write-Host "  Provider: $Provider" -ForegroundColor Gray
Write-Host "  Downloading installer..." -ForegroundColor Gray

# Download and execute the full installer
$installerUrl = "https://raw.githubusercontent.com/IrisGoLab/pcclaw/main/scripts/install.ps1"

# Build parameters
$installParams = @{
    ApiKey = $ApiKey
    AgentName = $AgentName
    Provider = $Provider
}
if ($BaseUrl) {
    $installParams.BaseUrl = $BaseUrl
}

try {
    $installer = Invoke-WebRequest -Uri $installerUrl -UseBasicParsing
    $scriptBlock = [ScriptBlock]::Create($installer.Content)

    # Execute with parameters
    & $scriptBlock @installParams
} catch {
    Write-Host ""
    Write-Host "  Could not download installer from GitHub" -ForegroundColor Yellow
    Write-Host "  Trying local execution..." -ForegroundColor Gray

    # Fallback: try to find local installer
    $localPath = "$PSScriptRoot\install.ps1"
    if (Test-Path $localPath) {
        & $localPath @installParams
    } else {
        Write-Host ""
        Write-Host "  Error: Could not find installer" -ForegroundColor Red
        Write-Host "  Please download manually from: https://openclaw.irisgo.xyz"
        throw "Could not find installer."
    }
}

} catch {
    Write-Host ""
    Write-Host "  ERROR: $_" -ForegroundColor Red
    Write-Host "  $($_.ScriptStackTrace)" -ForegroundColor DarkGray
} finally {
    Write-Host ""
    Read-Host "  Press Enter to close"
}
