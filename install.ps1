<#
.SYNOPSIS
  Install these skills for one or more AI coding agents.

.EXAMPLE
  .\install.ps1                       # all agents, user-level
  .\install.ps1 -Agent cursor,codex   # selected agents
  .\install.ps1 -Agent cursor -Project D:\code\my-app
  .\install.ps1 -Agent all -Uninstall

.EXAMPLE
  # Remote, without cloning:
  irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1 | iex
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/ray0807/opc-skills/main/install.ps1))) -Agent cursor
#>
param(
    [ValidateSet('all', 'claude', 'cursor', 'codex', 'gemini', 'agents')]
    [string[]]$Agent = @('all'),
    [string]$Project,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$Repo = 'ray0807/opc-skills'
$Branch = 'main'

$TempDir = $null
$SourceDir = if ($PSScriptRoot) { Join-Path $PSScriptRoot 'skills' }
if (-not $SourceDir -or -not (Test-Path $SourceDir)) {
    $TempDir = Join-Path ([IO.Path]::GetTempPath()) ("opc-skills-" + [guid]::NewGuid())
    $zip = "$TempDir.zip"
    Write-Host "Downloading $Repo@$Branch ..."
    Invoke-WebRequest "https://github.com/$Repo/archive/refs/heads/$Branch.zip" -OutFile $zip -UseBasicParsing
    Expand-Archive $zip $TempDir -Force
    Remove-Item $zip
    $SourceDir = Join-Path (Get-ChildItem $TempDir -Directory | Select-Object -First 1).FullName 'skills'
}

$AgentDirs = [ordered]@{
    claude = '.claude\skills'
    cursor = '.cursor\skills'
    codex  = '.codex\skills'
    gemini = '.gemini\skills'
    agents = '.agents\skills'
}

if ($Agent -contains 'all') { $Agent = @($AgentDirs.Keys) }
$Base = if ($Project) { (Resolve-Path $Project).Path } else { $HOME }
$Skills = Get-ChildItem $SourceDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }

foreach ($a in $Agent) {
    $target = Join-Path $Base $AgentDirs[$a]
    foreach ($s in $Skills) {
        $dest = Join-Path $target $s.Name
        if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        if (-not $Uninstall) {
            New-Item -ItemType Directory -Force -Path $target | Out-Null
            Copy-Item $s.FullName $dest -Recurse
        }
    }
    $verb = if ($Uninstall) { 'Removed' } else { 'Installed' }
    Write-Host ("{0} {1} skills for {2,-6} -> {3}" -f $verb, $Skills.Count, $a, $target)
}

if ($TempDir) { Remove-Item $TempDir -Recurse -Force }
