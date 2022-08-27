#!/bin/ruby
#This file contains the Git class that will perform a series of functions

# Gems
require "git"
require "dir"

#User defined classes/Gems

require "./util.rb"
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

    #Add the files to a repo with a commit message
    def self.postTo(uid, file, commitMsg)
        if !Dir.exist?($path)
            Dir.mkdir($path)
        end
        # Creating a test file to add 
        File.open("#$path/#{uid}/test.txt", "w") do |f|
            f.write(file)
        end
        # Adding all files into the Git
        g = Git.open("#$path", repository:"#$path/#{uid}/proj.git")
        g.add
        g.commit(commitMsg)

        return "posting the attached file for uid " + uid
    end

    #Get the diff for a file, need to enumerate through commits until a diff is found. return false if no diff is found return true with the commit SHA if a dif was found
    def self.getDif(uid, fileName)
        g = Git.open("#$path", repository:"#$path/#{uid}/proj.git")
        commits = g.log
        idx = 0
        #Hacking solution to get the count. There must be a better way!
        commits.each do |c|
            idx += 1
        end
        length = idx
        idx = 0
        found = false
        difCommit = ""
        while idx < length
            diff = g.diff(commits[idx], commits[idx+1]).path("#$path/#{uid}/#{fileName}")
            if diff.size() != 0
                puts "Dif found, returning"
                found = true
                difCommit = commits[idx+1]
                break
            end
            idx += 1
        end
        return Response.diffOutcome(found, difCommit)  
    end

end
