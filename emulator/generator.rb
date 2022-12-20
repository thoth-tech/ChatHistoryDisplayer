#!/bin/ruby
# frozen_string_literal: true

# This file contains the Git class that will perform a series of functions

# Gems
require 'git'
require 'dir'
require 'fileutils'
require 'json'

# User defined classes/Gems

require './util'

# Service to handle git
class GitGenerator
  @path = "#{Dir.pwd}/users"

  # creates a user directory
  # if a user directory already exists, then return :user_directory_exist
  # if a user directory is created, then return :user_directory_created
  def self.create_user_dir(user_id)
    return :user_directory_exist if user_dir_exist?(user_id)

    Dir.mkdir("#{@path}/#{user_id}")
    :user_creation_success
  end

  # returns whether the user dir exists
  def self.user_dir_exist?(user_id)
    Dir.exist?("#{@path}/#{user_id}")
  end

  # if the project repo exists, return nil
  # else, make the project dir in the user's dir and init the proj dir as git repo
  def self.create_project_repo(user_id, project_name)
    # if the project directory already exists, return
    return :project_directory_exist if project_repo_exist?(user_id, project_name)

    # create the project directory within the user's directory
    Dir.mkdir("#{@path}/#{user_id}/#{project_name}")

    # create the file_diffs directory within the user's project directory
    Dir.mkdir("#{@path}/#{user_id}/#{project_name}/file_diffs")

    # create .gitignore file in ./users/:user_id/:project_name
    # this will ignore each user's project's file_diffs directory
    File.write("#{@path}/#{user_id}/#{project_name}/.gitignore", 'file_diffs/*')

    # initialise the project dir as a local repo and configure it
    g = Git.init("#{@path}/#{user_id}/#{project_name}",
                 { repository: "#{@path}/#{user_id}/#{project_name}/.git",
                   index: "#{@path}/#{user_id}/#{project_name}/.git/index" })
    g.config('user.email', 'administrator@example.com')

    # set the required files for the project (i.e. create required.json)
    set_required_files(user_id, project_name, { 'requiredFiles' => ['summary.txt', 'report.txt'] })

    :project_creation_success
  end

  # returns whether the user's task repo exists
  def self.project_repo_exist?(user_id, project_name)
    Dir.exist?("#{@path}/#{user_id}/#{project_name}")
  end

  # stages all tracked files
  def self.stage_tracked_files(user_id, project_name)
    g = Git.open("#{@path}/#{user_id}/#{project_name}")
    g.add
  end

  # commits all staged files, if there are staged files
  def self.commit_staged_files(user_id, project_name, commit_message)
    g = Git.open("#{@path}/#{user_id}/#{project_name}")
    g.commit(commit_message)
  end

  # diffs a file, such that a diff will be present if the staged file differs from the committed file
  # the diff var will be empty if no difference is present
  def self.diff_file(user_id, project_name, file_name)
    g = Git.open("#{@path}/#{user_id}/#{project_name}")
    diff = g.diff.path("#{@path}/#{user_id}/#{project_name}/#{file_name}")
    diff.to_s
  end

  # set the required files for a specific user's project
  def self.set_required_files(user_id, project_name, files)
    File.write("#{@path}/#{user_id}/#{project_name}/required.json", JSON.pretty_generate(files))
    g = Git.open("#{@path}/#{user_id}/#{project_name}")
    g.add("#{@path}/#{user_id}/#{project_name}/required.json")
    g.commit('auto: set required files for project task')

    true
  end

  # creates a file in a user's project repository (./users/:user_id/:project_name/)
  # file is created using a json payload
  def self.create_file_from_payload(user_id, project_name, file_data)
    return :project_directory_missing unless Dir.exist?("#{@path}/#{user_id}/#{project_name}")

    # parsing the payload into a hash
    payload = JSON.parse(file_data)

    # writing to file from payload
    file = File.open("#{@path}/#{user_id}/#{project_name}/#{payload['fileName']}", 'w')
    file.write(payload['fileContents'])
    file.close

    # adding file to staging area and committing file to local git history of ./users/:user_id/:project_name
    g = Git.open("#{@path}/#{user_id}/#{project_name}")
    g.add

    create_diff_file(user_id, project_name, (payload['fileName']).to_s)

    # unless there's something to commit, don't commit
    g.commit("auto: add #{payload['fileName']}") unless g.diff.to_s.empty?

    :file_creation_success
  end

  # creates a file at ./users/:user_id/:project_name/file_diffs/:file_name
  # this file contains the latest diff of that file
  def self.create_diff_file(user_id, project_name, file_name)
    diff_string = diff_file(user_id, project_name, file_name)

    # if there's no diff, then return :no_diff_exist
    return :no_diff_exist if diff_string.empty?

    # write file
    file = File.open("#{@path}/#{user_id}/#{project_name}/file_diffs/#{file_name}", 'w')
    file.write(diff_string)
    file.close

    :diff_file_creation_success
  end

  def self.get_diff_string_from_file(user_id, project_name, file_name)
    return :file_not_found unless File.exist?("#{@path}/#{user_id}/#{project_name}/file_diffs/#{file_name}")

    file = File.open("#{@path}/#{user_id}/#{project_name}/file_diffs/#{file_name}", 'r')
    file.read
  end

  # deletes user directory
  def self.delete_user_dir(user_id)
    return :user_missing unless user_dir_exist?(user_id)

    FileUtils.rm_rf("#{@path}/#{user_id}")
    :user_deletion_success
  end

  # deletes user's project directory
  def self.delete_project_dir(user_id, project_name)
    return :project_missing unless project_repo_exist?(user_id, project_name)

    FileUtils.rm_rf("#{@path}/#{user_id}/#{project_name}")
    :project_deletion_success
  end

  # deletes a file in a project directory
  def self.delete_file(user_id, project_name, file_name)
    return :file_missing unless Dir.exist?("#{@path}/#{user_id}/#{project_name}/#{file_name}")

    # remove the file
    FileUtils.rm_rf("#{@path}/#{user_id}/#{project_name}/#{file_name}")

    # instantiate a git object and commit the deletion
    g = Git.open("#{@path}/#{user_id}/#{project_name}")
    g.add("#{@path}/#{user_id}/#{project_name}/#{file_name}")
    g.commit('auto: file deleted')

    :file_deletion_success
  end

  # get the required files for a specific user's project
  def self.get_required_files(user_id, project_name)
    return false unless project_repo_exist?(user_id, project_name)

    file = File.open("#{@path}/#{user_id}/#{project_name}/required.json", 'r')
    file_contents = file.read
    file.close

    JSON.parse(file_contents)
  end

  # check if all the required files for a project, as dictated by required.json,
  # are present
  def self.required_files_exist?(user_id, project_name)
    return :required_files_not_found unless project_repo_exist?(user_id, project_name)

    existing_files = Dir.entries("#{@path}/#{user_id}/#{project_name}/.")
    required_files = get_required_files(user_id, project_name)['requiredFiles']

    # if a required file is not in the existing
    required_files.each do |required_file|
      unless existing_files.include?(required_file)
        puts "#{required_file} not in existing_files"
        return :required_files_not_found
      end
    end

    :required_files_found
  end

  # does the file exist?
  def self.file_exist?(user_id, project_name, file_name)
    File.exist?("#{@path}/#{user_id}/#{project_name}/#{file_name}")
  end

  # Return the git log for a repo with all commits made
  def self.get_log(user_id, project_name)
    return false unless Dir.exist?(@path)

    g = Git.open("#{@path}/#{user_id}/#{project_name}")
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
