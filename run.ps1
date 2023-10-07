﻿# PowerShell Script to Download a ZIP from Google Drive, Unzip, and Run Pip Install & Test.py

# Optional: Cleanup downloaded and unpacked files
Remove-Item -Path $localZipPath -Force
Remove-Item -Path $unzipFolder -Recurse -Force

# Define the URL and local paths
$url = "https://drive.google.com/uc?id=1SSDF_N0-YOLKhKbDIDuB89rZpxzToHo8"
$localZipPath = ".\tempDownload.zip"
$unzipFolder = ".\unpackedContent"

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
DownloadFile -url $url -path $localZipPath
UnzipFile -zipPath $localZipPath -destFolder $unzipFolder

# Navigate to the unzipped folder
Push-Location -Path $unzipFolder

# Install Python requirements
Write-Host "Installing Python requirements..."
Invoke-Expression "pip install -r requirements.txt"
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