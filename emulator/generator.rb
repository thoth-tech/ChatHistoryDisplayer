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

  # if the user dir does not exist, then return nil
  # else, side-effect: create the user dir
  def self.create_user_dir(uid)
    return if user_dir_exist?(uid)

    Dir.mkdir("#{@path}/#{uid}")
  end

  # returns whether the user dir exists
  def self.user_dir_exist?(uid)
    Dir.exist?("#{@path}/#{uid}")
  end

  # if the project repo exists, return nil
  # else, make the project dir in the user's dir and init the proj dir as git repo
  def self.create_project_repo(uid, project_name)
    return if project_repo_exist?(uid, project_name)

    Dir.mkdir("#{@path}/#{uid}/#{project_name}")
    g = Git.init("#{@path}/#{uid}/#{project_name}",
                { repository: "#{@path}/#{uid}/#{project_name}/.git",
                  index: "#{@path}/#{uid}/#{project_name}/.git/index" })
    g.config('user.email', 'testemail@gmail.com')

    set_required_files(uid, project_name, { 'requiredFiles' => ['summary.txt', 'report.txt'] })
  end

  # returns whether the user's task repo exists
  def self.project_repo_exist?(uid, project_name)
    Dir.exist?("#{@path}/#{uid}/#{project_name}")
  end

  # stages all tracked files
  def self.stage_tracked_files(uid, project_name)
    g = Git.open("#{@path}/#{uid}/#{project_name}")
    g.add
  end

  # commits all staged files, if there are staged files
  def self.commit_staged_files(uid, project_name, commit_message)
    g = Git.open("#{@path}/#{uid}/#{project_name}")
    g.commit(commit_message)
  end

  # diffs a file, such that a diff will be present if the staged file differs from the committed file
  # the diff var will be empty if no difference is present
  def self.diff_file(uid, project_name, file_name)
    g = Git.open("#{@path}/#{uid}/#{project_name}")
    diff = g.diff.path("#{@path}/#{uid}/#{project_name}/#{file_name}")
    diff.empty? ? Response.diff_outcome(false, diff) : Response.diff_outcome(true, diff)
  end

  # set the required files for a specific user's project
  def self.set_required_files(uid, project_name, files)
    File.write("#{@path}/#{uid}/#{project_name}/required.json", JSON.pretty_generate(files))
    g = Git.open("#{@path}/#{uid}/#{project_name}")
    g.add
    g.commit('auto: set required files for project task')

    true
  end

  # get the required files for a specific user's project
  def self.get_required_files(uid, project_name)
    return false unless project_repo_exist?(uid, project_name)

    f = File.read("#{@path}/#{uid}/#{project_name}/required.json")
    JSON.parse(f)
  end

  # check if all the required files for a project, as dictated by required.json,
  # are present
  def self.required_files_exist?(uid, project_name)
    return false unless project_repo_exist?(uid, project_name)

    existing_files = Dir.entries("#{@path}/#{uid}/#{project_name}/.")
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
  def self.get_log(uid, project_name)
    return false unless Dir.exist?(@path)

    g = Git.open("#{@path}/#{uid}/#{project_name}")
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
