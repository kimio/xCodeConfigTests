require './XcodeConfig'
xcode = XcodeConfig.new()
#Build and report
xcworkspace = ARGV[0]
scheme = ARGV[1]
id = ARGV[2]
xcode.buildOnXcBuild(xcworkspace, scheme, id)