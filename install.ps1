Write-Host "Welcome to the PyEnv easy installer."
Write-Host "Downloading PyEnv..."
Invoke-WebRequest 'https://github.com/pyenv-win/pyenv-win/archive/master.zip' -OutFile $env:temp/pyenv-win.zip > $null

Expand-Archive -LiteralPath $env:temp\pyenv-win.zip -DestinationPath $env:TEMP\pyenv-win -Force
if(Test-Path $HOME\.pyenv){
    Write-Host "${HOME}\.pyenv exists, deleting..."
    Remove-Item -Recurse -Force -Path $HOME\.pyenv > $null
}
Write-Host "Adding PyEnv to ${HOME}\.pyenv"
New-Item -Path $HOME\.pyenv -ItemType Directory -Force > $null
Move-Item -Path $env:temp\pyenv-win\pyenv-win-master\* -Destination $HOME\.pyenv -Force > $null
Write-Host "PyEnv download complete! Completing installation..."
Write-Host "Setting path..."

[System.Environment]::SetEnvironmentVariable('PYENV',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
[System.Environment]::SetEnvironmentVariable('PYENV_HOME',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
[System.Environment]::SetEnvironmentVariable('path', $HOME + "\.pyenv\pyenv-win\bin;" + $HOME + "\.pyenv\pyenv-win\shims;" + $env:Path,"User")

# this essentially refreshes the shell, letting us use the pyenv commands.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

$currdir = Get-Location

Set-Location -Path $HOME
Write-Host "Rehashing and updating PyEnv"
pyenv rehash
pyenv update

Write-Host "`n`nSelect a version of python to install:"
Write-Host "1) Python 3.7"
Write-Host "2) Python 3.8"
Write-Host "3) Python 3.9"
Write-Host "If unsure, select Python 3.9."

do {
    $pychoice = Read-Host "`nEnter your selection"
} until (($pychoice -eq '1') -or ($pychoice -eq '2') -or ($pychoice -eq '3'))

$pyver = ""

switch ($pychoice) {
    '1' {
        $pyver = "3.7.9"
        
    }
    '2' {
        $pyver = "3.8.7"
    }
    '3' {
        $pyver = "3.9.1"
    }
}

pyenv install $pyver
pyenv global $pyver
pyenv rehash

Set-Location $currdir

Write-Host "`nSuccessfully used pyenv to install python${pyver}"
