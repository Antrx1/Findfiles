Write-Host "Enter the software name"

$softwareName = Read-Host "Enter Software Name"
$escapedSoftwareName = [System.Management.Automation.WildcardPattern]::Escape($softwareName)

# Path to look for
$searchPath = "C:\"
$registryPath = "HKLM:\Software"

# Search for files
$fileResults = Get-ChildItem -Path $searchPath -Recurse | Where-Object {
    $_.FullName -match ".*$escapedSoftwareName.*" -or $_.Name -match ".*$escapedSoftwareName.*"
}

# Search for registry entries
$registryResults = Get-ChildItem -Path $registryPath -Recurse | Get-ItemProperty | Where-Object {
    $_.PSChildName -match ".*$escapedSoftwareName.*"
}

if ($fileResults.Count -eq 0 -and $registryResults.Count -eq 0) {
    Write-Host "No files or registry entries related to '$softwareName' were found."
} else {
    Write-Host "Files and/or registry entries related to '$softwareName' were found:"
    
    foreach ($file in $fileResults) {
        Write-Host "File: $($file.FullName)"
    }

    foreach ($registryEntry in $registryResults) {
        Write-Host "Registry Entry: $($registryEntry.PSChildName)"
    }
}
