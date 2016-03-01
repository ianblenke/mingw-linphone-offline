$tools = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. (Join-Path $tools chocolateyInclude.ps1)

$extension = "7z"
$zipFile = "$packageName.$extension"
$offline = Join-Path $tools $zipFile

$relPath = $offline -replace ':','|'
$url = "file:///" + $relPath -replace '\\','/'
Write-Debug "Using local $zipFile, at $url"

Install-ChocolateyZipPackage "$packageName" "$url" "$installDir"

##############################################################
#Per instructions (http://www.mingw.org/wiki/Getting_Started),
#set user path (for cmd.exe usage) 
##############################################################

Write-Host "Adding `'$installDir`' to the (user) path and the current shell path."
Install-ChocolateyPath "$installDir\bin" 'User'
$env:Path = "$($env:Path);$installDir\bin"

#############################################################
#Per instructions (https://github.com/BelledonneCommunications/linphone/blob/master/README.mingw#L28),
#several mingw modules must now be installed.
#############################################################

#The chocolatey packaged offline (--download-only) modules
#now must be extracted...
$modules = @(
    "mingw-developer-toolkit",
    "mingw32-base",
    "mingw32-gcc-g++",
    "mingw32-pthreads-w32",
    #'mingw-get install' errors, saying "msys-base" is already installed, so commented...
    #"msys-base",
    "msys-zip",
    "msys-unzip",
    "msys-wget"
)

foreach ($module in $modules){
    Write-Host "Install $module"
    mingw-get install $module
    Write-Debug "The exit code: $LASTEXITCODE $?"
}

##############################################################
#Per instructions (http://www.mingw.org/wiki/Getting_Started),
#adjust fstab.  This step must occur last.
##############################################################

$msysFstab = Join-Path $installDir "msys\1.0\etc\fstab"
Add-Content $msysFstab "$installDir /mingw`n"
