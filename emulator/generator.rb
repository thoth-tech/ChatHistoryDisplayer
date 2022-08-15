#!/bin/ruby
#This file contains the Git class that will perform a series of functions

# Gems
require "git"
require "dir"
class GitGenerator
    #Class variables
    $path = Dir.pwd() + "/repos"

    # Test function to test connectivity
    def self.test()
        return true
    end

    def self.init(uid)
        # Creating a directory to host the git repo
        if !Dir.exist?($path) 
            Dir.mkdir($path)
        end
        if Dir.exist?($path+"/#{uid}")
            Dir.mkdir($path+"/#{uid}")
        end
        g = Git.init("#$path/#{uid}",
            { :repository => "#$path/#{uid}/proj.git",
                :index => "#$path/#{uid}/index"} )
        return true
    end

    def self.retrieve(uid)
        return "retrieving repo for uid " + uid
    end

    def self.postTo(uid, file)
        return "posting the attached file for uid " + uid
    end
end
