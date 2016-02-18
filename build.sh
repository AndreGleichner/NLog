#!/bin/bash

DNXVERSION="1.0.0-rc1-update1"
DOWNLOAD_CAKE_BUILD_BOOTSTRAP="curl -Lsfo buildcake.sh http://cakebuild.net/bootstrapper/linux"

if [ ! -f ~/.dnx/dnvm/dnvm.sh ] 
then
echo "Downloading dnvm"
curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh && source ~/.dnx/dnvm/dnvm.sh
else
echo "Using installed dnvm.sh script"
source ~/.dnx/dnvm/dnvm.sh
fi

dnvm install $DNXVERSION -a x64 -r coreclr
dnvm install $DNXVERSION -a x64 -r mono -alias default

dnvm use default

dnu restore --quiet
dnu build src/NLog --quiet
dnu build src/NLog.Extended --quiet
dnu build src/NLog.Extended --quiet
dnu build src/NLogAutoLoadExtension --quiet
dnu build tests/SampleExtensions --quiet
dnu build tests/NLog.UnitTests --quiet

dnx -p tests\NLog.UnitTests test
