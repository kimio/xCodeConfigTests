require "open3"
require 'date'

class XcodeConfig
    #Create new ram disk
    def createRamDisk
        #if not exists
        stdout, stdeerr, status = Open3.capture3("diskutil list | grep XCodeDerivedData | awk '{print $NF}'")
        if stdout.length < 1
        puts "creating new ram disc"
        stdout, stdeerr, status = Open3.capture3("hdid -nomount ram://33554432")
        else
        stdout = "/dev/" + stdout
        end
        @ramDisk = stdout
    end
    #Set new Xcode Config
    def writeXcodeConfig
        stdout, stdeerr, status = Open3.capture3("
        defaults write com.apple.Xcode PBXNumberOfParallelBuildSubtasks 4
        defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
        defaults write com.apple.dt.XCode IDEIndexDisable 0
        defaults write com.apple.Xcode XCMaxNumberOfDistributedTasks 60")
    end
    #Set DerivedData in new ram disk
    def setDerivedData
        stdout, stdeerr, status = Open3.capture3("
        newfs_hfs -v XCodeDerivedData " + @ramDisk + "
        diskutil mount -mountPoint ~/Library/Developer/Xcode/DerivedData " + @ramDisk )
    end
    #Remove ram disk
    def removeRamDisk(ramDisk)
        stdout, stdeerr, status = Open3.capture3("hdiutil detach " + ramDisk)
    end
    #Build
    def build(workspace, scheme, id)
        puts 'Start '+DateTime.now.to_s
        puts 'Building...'
        command = ("xcodebuild -workspace " + workspace + "/ -scheme " + scheme + " -destination 'id=" + id + "'")
        exec command
    end
    #Build Test
    def buildTest(workspace, scheme, id)
        puts 'Start '+DateTime.now.to_s
        puts 'Building...'
        command = ("xcodebuild -workspace " + workspace + "/ -scheme " + scheme + " -destination 'id=" + id + "'")
        stdout, stdeerr, status = Open3.capture3(command)
        puts 'End '+DateTime.now.to_s
    end
    #Clean
    def clean(workspace, scheme)
        command = ("xcodebuild clean -workspace " +workspace+ "/ -scheme " + scheme)
        exec command
    end
    #Install xcbuild
    def installXcBuild()
        exec "brew install cmake ninja
        cd ~/
        git clone https://github.com/facebook/xcbuild
        cd xcbuild
        git submodule update --init
        make
        "
    end
    #Build on xcbuild
    def buildOnXcBuild(workspace, scheme, id)
        puts 'Start '+DateTime.now.to_s
        puts 'Building...'
        command = ("~/xcbuild/xcbuild/build/xcbuild -workspace " + workspace + "/ -scheme " + scheme + " -destination 'id=" + id + "'")
        exec command
        puts 'End '+DateTime.now.to_s
    end
end

