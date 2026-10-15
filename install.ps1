<#
.SYNOPSIS
  为一个或多个 AI agent 安装这些 skill。

.EXAMPLE
  .\install.ps1                       # 安装到所有 agent（用户级）
  .\install.ps1 -Agent cursor,codex   # 只装给指定 agent
  .\install.ps1 -Agent cursor -Project D:\code\my-app
  .\install.ps1 -Agent all -Uninstall

.EXAMPLE
  # 无需克隆，远程直接安装：
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
    Write-Host "正在下载 $Repo@$Branch ..."
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
    $verb = if ($Uninstall) { '已卸载' } else { '已安装' }
    Write-Host ("{0} {1} 个 skill（{2}）-> {3}" -f $verb, $Skills.Count, $a, $target)
}

if (-not $Uninstall) { Write-Host '完成。请重启 agent 或新开一个对话，让 skill 生效。' }
if ($TempDir) { Remove-Item $TempDir -Recurse -Force }
