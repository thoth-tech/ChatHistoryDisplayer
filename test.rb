#!/bin/ruby
 
require "rubygems"
require "git"
require "dir"

puts "Making a directory"

def make(arg)
    Git.init("test")
end

make("abcdcdc")