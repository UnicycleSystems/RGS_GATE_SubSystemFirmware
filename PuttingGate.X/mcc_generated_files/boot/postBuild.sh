# Give all arguments a more readable local variable name
export compilerDir="$1"
export projectDir="$2"
export imageDir="$3"
export imageName="$4"
export isDebug="$5"

# Local Variables
export reset="[0m"
export cyan="[46m"

if [ $isDebug = "true" ]; then
echo -e "$cyan NOTE: You have built in DEBUG mode, therefore a .hex file was not generated. If you would like to generate a .hex file, please build in production mode. For more information, please open MCC and click on the question mark symbol next to the 16-bit Bootloader Library under Resource Management. $reset"
exit 0
fi

hexmate r0-47FF,"$projectDir/$imageDir/$imageName" r4808-FFFFFFFF,"$projectDir/$imageDir/$imageName" -O"$projectDir/$imageDir/temp_original_copy.X.production.hex" -FILL=w1:0x00,0x00,0x00,0x00@0x4800:0x4807
hexmate r4800-FFFFFFFF,"$projectDir/$imageDir/temp_original_copy.X.production.hex" -O"$projectDir/$imageDir/temp_crc.X.production.hex" -FILL=w1:0xFF,0xFF,0xFF,0x00@0x4800:0x14FFF +-CK=4800-14FFF@15000w-4g5p814141AB
hexmate r15000-15001s-10800,"$projectDir/$imageDir/temp_crc.X.production.hex" r15002-15003s-107FE,"$projectDir/$imageDir/temp_crc.X.production.hex" r4806-FFFFFFFF,"$projectDir/$imageDir/$imageName" r4802-4803,"$projectDir/$imageDir/$imageName" r0-47FF,"$projectDir/$imageDir/$imageName" -O"$projectDir/$imageDir/$imageName"
rm "$projectDir/$imageDir/temp_original_copy.X.production.hex"
rm "$projectDir/$imageDir/temp_crc.X.production.hex"