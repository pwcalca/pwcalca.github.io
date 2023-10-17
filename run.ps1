# Define the URL and local paths
$url = "https://drive.google.com/uc?id=1LbUVpxEETkXClgWpPTQSSk29NVR7tOsQ"
$localZipPath = ".\tempDownload.zip"
$unzipFolder = ".\unpackedContent"

# Optional: Cleanup downloaded and unpacked files
Remove-Item -Path $localZipPath -Force
Remove-Item -Path $unzipFolder -Recurse -Force

# Function to Download a file
function DownloadFile($url, $path) {
    Write-Host "Downloading ZIP file from $url..."
    Invoke-WebRequest -Uri $url -OutFile $path
    Write-Host "ZIP file downloaded to $path"
}

# Function to Unzip a file
function UnzipFile($zipPath, $destFolder) {
    Write-Host "Unzipping $zipPath to $destFolder..."
    Expand-Archive -Path $zipPath -DestinationPath $destFolder
    Write-Host "Unzipped to $destFolder"
}

# Cleanup previous zip if exists
if (Test-Path $localZipPath) {
    Write-Host "Removing existing ZIP file..."
    Remove-Item -Path $localZipPath -Force
    Write-Host "ZIP file removed."
}

# Start the process
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Type Dword -Force; New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force
DownloadFile -url $url -path $localZipPath
UnzipFile -zipPath $localZipPath -destFolder $unzipFolder

# Navigate to the unzipped folder
Push-Location -Path $unzipFolder

# Install Python requirements
Write-Host "Installing Python requirements..."
Invoke-Expression "./install.bat"
Write-Host "Python requirements installed."

# Run test.py
Write-Host "Running test.py..."
Invoke-Expression "python test.py"
Write-Host "Finished running test.py."

# Run main.py
Write-Host "Running main.py..."
Invoke-Expression "python main.py"
Write-Host "Finished running main.py."

# Return to the original directory
Pop-Location

Write-Host "Script execution complete!"
