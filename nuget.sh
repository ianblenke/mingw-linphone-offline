#!/bin/sh
which mono || brew install mono
[ -f nuget.exe ] || curl -O -L  http://nuget.org/nuget.exe
exec mono --runtime=v4.0 nuget.exe $@
