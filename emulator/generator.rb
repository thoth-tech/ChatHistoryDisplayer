#!/bin/ruby
# frozen_string_literal: true

# This file contains the Git class that will perform a series of functions

# Gems
require 'git'
require 'dir'
require 'json'

# User defined classes/Gems

require './util'

# Service to handle git
class GitGenerator
  def self.init
    # the path to the repositories will be ./repos, where the root will be the pwd
    @path = "#{Dir.pwd}/repos"

    # if the path does not exist, then create the path
    Dir.mkdir(@path) unless Dir.exist?(@path)
  end

  # if a user does not have a repository, then create one
  def self.create_user_repo(uid)
    return if user_repo_exists?(uid)

    Dir.mkdir(@path + "/#{uid}")
    g = Git.init("#{@path}/#{uid}",
                 { repository: "#{@path}/#{uid}/proj.git",
                   index: "#{@path}/#{uid}/index" })
    g.config('user.email', 'testemail@gmail.com')

    set_required_files(uid, { 'requiredFiles' => ['summary.txt', 'report.txt'] })
  end

  # returns whether the user's repo exists
  def self.user_repo_exists?(uid)
    Dir.exist?("#{@path}/#{uid}")
  end

  # stages all tracked files
  def self.stage_tracked_files(uid)
    g = Git.open(@path, repository: "#{@path}/#{uid}/proj.git")
    g.add
  end

  # commits all staged files, if there are staged files
  def self.commit_staged_files(uid, commit_message)
    g = Git.open(@path, repository: "#{@path}/#{uid}/proj.git")
    g.commit(commit_message)
  end

  # diffs a file, such that a diff will be present if the staged file differs from the committed file
  # the diff var will be empty if no difference is present
  def self.diff_file(uid, file_name)
    g = Git.open(@path, repository: "#{@path}/#{uid}/proj.git")
    diff = g.diff.path("#{@path}/#{uid}/#{file_name}")
    diff.empty? ? Response.diff_outcome(false, diff) : Response.diff_outcome(true, diff)
  end

  # Set the required files for a given repo
  def self.set_required_files(uid, files)
    File.write("#{@path}/#{uid}/required.json", JSON.pretty_generate(files))
    g = Git.open(@path, repository: "#{@path}/#{uid}/proj.git")
    g.add
    g.commit('Setting required files for a submission')

    true
  end

  # Get the required files for a given repo
  def self.get_required_files(uid)
    return false unless user_repo_exists?(uid)

    f = File.read("#{@path}/#{uid}/required.json")
    JSON.parse(f)
  end

  # Check if all the required files have been uploaded
  def self.required_files_exist?(uid)
    return false unless user_repo_exists?(uid)

    existing_files = Dir.entries("#{@path}/#{uid}/.")
    required_files = get_required_files(uid)['requiredFiles']

    # if a required file is not in the existing
    required_files.each do |required_file|
      unless existing_files.include?(required_file)
        puts "#{required_file} not in existing_files"
        return false
      end
    end

    true
  end

  # Return the git log for a repo with all commits made
  def self.get_log(uid)
    return false unless Dir.exist?(@path)

    g = Git.open(@path.to_s, repository: "#{@path}/#{uid}/proj.git")
    commit_list = []
    log = g.log
    log.each do |commit_sha|
      # Extract the commit message of each commit
      commit = g.gcommit(commit_sha)
      obj = { 'sha' => commit_sha, 'message' => commit.message }
      commit_list.push(obj)
    end
    commit_list
  end
end
