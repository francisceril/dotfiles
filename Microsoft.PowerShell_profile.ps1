# Customize the prompt
function prompt {
    $prefix = $(if ($env:USER -eq "root" -or [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { '[ADMIN]: ' } else { '' })
    $body = 'PS ' + $(Get-Location)
    $suffix = $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
    $prefix + $body + $suffix
}

$scriptsDirectory = "$HOME/.powershell/"
$gitRepo = "https://github.com/francisceril/powershell.git"

if (-not (Test-Path $scriptsDirectory)) {
    # Clone remote repository
    try {
        # Create directory
        New-Item -Type Directory -Path "$HOME/.powershell" | Set-Location
        
        # Initialize Git
        git init

        # Add the remote repository
        git remote add -f origin $gitRepo
        
        # Enable sparse checkout
        git config core.sparseCheckout true

        # Specify directory to checkout
        Write-Output "functions/" >> .git/info/sparse-checkout

        # Checkout the repository
        git pull origin main

        # Change directory
        Set-Location -Path $env:USERPROFILE

        # Load functions
        try {
            # Load Functions
            $files = (Get-ChildItem -Path "$scriptsDirectory/functions" -Recurse -File)
    
            foreach ($file in $files) {
                $fileContent = [string]::Join([System.Environment]::NewLine, (Get-Content -Path $file.FullName))
                Invoke-Expression $fileContent
            }
        } catch {
            Exit 1
        }

        Clear-Host
    } catch {
        Write-Host "Unable to clone remote repository."
        Exit 1
    }
} else {
    try {
        # Load Functions
        $files = (Get-ChildItem -Path "$scriptsDirectory/functions" -Recurse -File)

        foreach ($file in $files) {
            $fileContent = [string]::Join([System.Environment]::NewLine, (Get-Content -Path $file.FullName))
            Invoke-Expression $fileContent
        }
    } catch {
        Exit 1
    }
}

