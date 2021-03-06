# =====TODO======
# Need a way to compare file properties and file version to use for an auto-fix
# Either keep previous downloaded file as reference or ideally store the version installed in registry
# Could be that there is already an entry that we can check in registry created by the installer.
# ===============

# Create tmp folder if it does not exist
$Path="c:\tmp"
if (!(Test-Path $Path))
{
New-Item -itemType Directory -Path C:\ -Name "tmp"
}

# Download the installer
$MarsAURL = "https://aka.ms/Azurebackup_Agent"
Invoke-WebRequest -Uri $MarsAURL -OutFile "C:\tmp\MARSAgentInstaller.EXE"

# Run the installer silently
Start-Process -FilePath "C:\tmp\MARSAgentInstaller.EXE" -ArgumentList "/q"
