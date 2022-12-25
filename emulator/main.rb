# frozen_string_literal: true

# Gems
require 'rubygems'
require 'git'
require 'dir'
require 'logger'
require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

# User defined classes/Gemsruby
require './generator'
require './util'

# HTTP Response boilerplate
set :bind, '0.0.0.0'

configure do
  enable :cross_origin
end

before do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# HTTP Response boilerplate
options '*' do
  response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
end

# API END-POINTS
# creates a user directory
get '/init/:user_id' do |user_id|
  response = GitGenerator.create_user_dir(user_id)

  case response
  when :user_creation_success
    Response.generic('201', 'User directory created successfully!')
  when :user_directory_exist
    Response.generic('404', 'User directory already exists.')
  end
end

# creates a project directory
get '/init/:user_id/:project_id' do |user_id, project_id|
  response = GitGenerator.create_project_repo(user_id, project_id)

  case response
  when :project_creation_success
    Response.generic('201', 'Project directory created successfully!')
  when :project_directory_exist
    Response.generic('404', 'Project directory already exists')
  end
end

# use a json payload to upload a file
post '/:user_id/:project_name' do |user_id, project_name|
  request.body.rewind
  payload = request.body.read
  response = GitGenerator.create_file_from_payload(user_id, project_name, payload)

  case response
  when :file_creation_success
    Response.generic('201', 'File created.')
  when :project_directory_missing
    Response.generic('404', 'Project directory missing.')
  end
end

# deleting a user's directory
delete '/:user_id' do |user_id|
  response = GitGenerator.delete_user_dir(user_id)

  case response
  when :user_deletion_success
    Response.generic('201', 'User directory removed successfully!')
  else
    Response.generic('404', 'User directory not found.')
  end
end

# deleting a user's project directory
delete '/:user_id/:project_name' do |user_id, project_name|
  response = GitGenerator.delete_project_dir(user_id, project_name)

  case response
  when :project_deletion_success
    Response.generic('201', 'Project directory removed successfully!')
  when :project_missing
    Response.generic('404', 'Project directory not found.')
  end
end

# deleting a user's project's file
delete '/:user_id/:project_name/:file_name' do |user_id, project_name, file_name|
  response = GitGenerator.delete_file(user_id, project_name, file_name)

  case response
  when :file_deletion_success
    Response.generic('201', 'File removed successfully!')
  when :file_missing
    Response.generic('404', 'File not found.')
  end
end

#### [TODO] Need to create test case in spec/api_spec
# gets the diff string from the diff file
get '/diff/:user_id/:project_name/:file_name' do |user_id, project_name, file_name|
  if GitGenerator.file_exist?(user_id, project_name, file_name)
    response = GitGenerator.get_diff_string_from_file(user_id, project_name, file_name)
  else
    response = :file_not_found
  end

  case response
  when :file_not_found
    Response.generic('404', 'File not found.')
  else
    Response.generic('201', response)
  end
end

#### [TODO] Need to create test case in spec/api_spec
# get whether a file exists in a user's project dir
get '/file_exist/:user_id/:project_name/:file_name' do |user_id, project_name, file_name|
  response = GitGenerator.file_exist?(user_id, project_name, file_name)

  case response
  when true
    Response.generic('201', 'File found.')
  else
    Response.generic('404', 'File not found.')
  end
end

#### [TODO] Need to create test case in spec/api_spec
# get the status of a user's project (are all required files present?)
get '/required_files/:user_id/:project_name' do |user_id, project_name|
  response = GitGenerator.required_files_exist?(user_id, project_name)

  case response
  when :required_files_found
    Response.generic('201', 'File found.')
  when :required_files_not_found
    Response.generic('404', 'File not found.')
  end
end
