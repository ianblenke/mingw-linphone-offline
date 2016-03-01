## MinGW Offline Distro for Linphone Build

Linphone depends on MinGW, but the installation and configuration of MinGW is labor intensive process.  This repo
is a Chocolatey/NuGet package build project which makes the installation of MinGW this simple:

    choco install mingw-linphone-offline

All the MinGW add-on modules needed by Linphone are already downloaded and stored in the chocolatey package.  This
was accomplished using a feature of mingw: `mingw-get install --download-only <module name>`.  In turn, chocolatey
itself can be directed to use packages available from an offline location:

    $chocPackages = Join-Path $scriptPath 'packages'
    choco source add -n=local -s"$chocPackages"

When this `mingw-linphone-offline` package is placed into an offline package source folder (such as `$chocPackages`
from the above example) it allows a box provisioning tool (e.g. "vagrant up") to quickly install MinGW without
requiring the `mingw-linphone-offline` package to be downloaded.

The `mingw-linphone-offline` chocolatey package, when installed, executes `mingw-get install <module>` commands
to extract and install the "--download-only" modules.  

In short, this is as modular or self-contained as this MinGW setup for linphone can possibly be.

###The MinGW Zip File

This chocolatey package build depends on the file `MinGW-linphone-offline.7z` which is included.  The content
of this zip was already covered in passing above.  However, the detailed instructions for how to create
the zip file, should it ever need to be re-created, are as follows:

 * Download mingw-get-setup.exe and execute.  In the GUI, uncheck the gui option.  
   Note: The installation 
   directory will default to C:\mingw, but that location will become irrelevant when following these instructions.
 * For convenience, set a path to the mingw bin directory (c:\mingw\bin).  It does not matter if these path is 
   temporary (active only for the present shell) because the result will simply zipped and shipped to other boxes.
 * Run this: mingw-get update
 * Run these:  
    mingw-get install --download-only mingw-developer-toolkit  
    mingw-get install --download-only mingw32-base  
    mingw-get install --download-only mingw32-gcc-g++  
    mingw-get install --download-only mingw32-pthreads-w32  
    mingw-get install --download-only msys-base  
    mingw-get install --download-only msys-zip  
    mingw-get install --download-only msys-unzip  
 * From within the c:\mingw folder, zip the contents:`7za a -r mingw-linphone-offline`  
   Note: The zip file will not include the root "mingw" folder, which makes it easier for chocolatey to select parametrically the final folder.
 * Place the newly created zip file into the `tools` folder of this repository.
 * Run `nuget pack` against the package.nuspec of this repository.   
 
 
