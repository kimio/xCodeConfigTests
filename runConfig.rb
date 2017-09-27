require './XcodeConfig'
xcode = XcodeConfig.new()
#Create ram disk
xcode.createRamDisk();
#Update Xcode Config
xcode.writeXcodeConfig();
#Set derived data
xcode.setDerivedData();