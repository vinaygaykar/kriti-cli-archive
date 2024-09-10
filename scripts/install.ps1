# This script is for installing the latest version of Kriti CLI on your Windows machine.

# Function to probe the architecture
function Probe-Arch {
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    switch ($arch) {
        "AMD64" { return "x86_64" }
        "ARM64" { return "arm64" }
        default { Write-Host "Architecture $arch is not supported"; exit 1 }
    }
}

# Function to detect the OS (always "windows" in this case)
function Probe-OS {
    return "windows"
}

# Function to update the PATH
function Update-PathEnvironment {
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$INSTALL_DIRECTORY*") {
        $newPath = "$currentPath;$INSTALL_DIRECTORY"
        [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "Updated PATH environment variable."
    }
    else {
        Write-Host "PATH already contains the Kriti directory."
    }
}

# Function to install Kriti CLI
function Install-KritiCLI {
    $urlPrefix = "https://github.com/vinaygaykar/kriti-cli-archive/releases/latest/download/"
    $target = "${OS}_$ARCH"

    Write-Host "Downloading $target ..."

    $url = "$urlPrefix/kriti_$target.zip"
    $downloadFile = [System.IO.Path]::GetTempFileName()

    Invoke-WebRequest -Uri $url -OutFile $downloadFile -UseBasicParsing

    Write-Host "Installing to $INSTALL_DIRECTORY"
    New-Item -ItemType Directory -Force -Path $INSTALL_DIRECTORY | Out-Null
    Expand-Archive -Path $downloadFile -DestinationPath $INSTALL_DIRECTORY -Force
    Remove-Item -Path $downloadFile -Force
}

# Main execution
Write-Host "Welcome to the Kriti installer!"

$ARCH = Probe-Arch
$OS = Probe-OS
$INSTALL_DIRECTORY = "$env:USERPROFILE\.kriti"

Install-KritiCLI
Update-PathEnvironment

Write-Host "Kriti CLI installed!"
Write-Host "To get started, open a new PowerShell window and run 'kriti login'."