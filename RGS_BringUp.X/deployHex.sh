#!/bin/sh
# Mirror of deployHex.bat for non-Windows builds; see that file for details.
# Args: $1 projectDir  $2 imageDir  $3 imageName  $4 confName  $5 isDebug

projectDir="$1"
imageDir="$2"
imageName="$3"
confName="$4"
isDebug="$5"

dropRoot="C:/SubSystemFirmware/BatteryConfigBuilds"
versionFile="$projectDir/firmware_version.h"

if [ "$isDebug" = "true" ]; then
  echo "[deployHex] Debug build - no hex produced, nothing to drop."
  exit 0
fi

MSB=$(awk '/define[ \t]+FIRMWARE_REV_MSB/ {print $3}' "$versionFile")
LSB=$(awk '/define[ \t]+FIRMWARE_REV_LSB/ {print $3}' "$versionFile")

if [ -z "$MSB" ] || [ -z "$LSB" ]; then
  echo "[deployHex] ERROR: firmware revision not found in $versionFile"
  exit 1
fi

srcHex="$projectDir/$imageDir/$imageName"
if [ ! -f "$srcHex" ]; then
  echo "[deployHex] ERROR: built hex not found: $srcHex"
  exit 1
fi

outDir="$dropRoot/$confName"
mkdir -p "$outDir" || { echo "[deployHex] ERROR: could not create $outDir"; exit 1; }

outName="RGS_BATT_${confName}_${MSB}_${LSB}.hex"

cp -f "$srcHex" "$outDir/$outName" || {
  echo "[deployHex] ERROR: copy failed to $outDir/$outName"
  exit 1
}

echo "[deployHex] $outDir/$outName"
exit 0
