#!/bin/ruby
#This file contains the Git class that will perform a series of functions

class GitGenerator
    # Test function to test connectivity
    def self.test()
        return true
    end

    def self.init()
        return 'initialising master repo'
    end

    def self.retrieve(uid)
        return "retrieving repo for uid " + uid
    end

    def self.postTo(uid, file)
        return "posting the attached file for uid " + uid
    end
end
