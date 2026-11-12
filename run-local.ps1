[CmdletBinding()]
param(
    [switch]$Drafts,
    [ValidateRange(1024, 65535)][int]$Port = 4000
)

$ErrorActionPreference = 'Stop'
$jekyllArgs = @('exec', 'jekyll', 'serve', '--host', '127.0.0.1', '--port', "$Port")
if ($Drafts) { $jekyllArgs += '--drafts' }

Push-Location $PSScriptRoot
try {
    if ((Get-Command ruby -ErrorAction SilentlyContinue) -and (Get-Command bundle -ErrorAction SilentlyContinue)) {
        & bundle check
        if ($LASTEXITCODE -ne 0) { throw 'Install dependencies with bundle install before previewing.' }
        & bundle @jekyllArgs
    }
    elseif (Get-Command wsl -ErrorAction SilentlyContinue) {
        # WSL inherits this working directory; no interpolated shell command is needed.
        & wsl -d Ubuntu -- bundle check
        if ($LASTEXITCODE -ne 0) { throw 'Install dependencies with wsl -d Ubuntu -- bundle install before previewing.' }
        & wsl -d Ubuntu -- bundle @jekyllArgs
    }
    else {
        throw 'Install Ruby and Bundler, or enable Ubuntu WSL with Ruby and Bundler.'
    }
    if ($LASTEXITCODE -ne 0) { throw "Jekyll exited with code $LASTEXITCODE." }
}
finally {
    Pop-Location
}
