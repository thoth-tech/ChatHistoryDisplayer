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

# REST API METHODS HERE

# creates a user directory
get '/init/:uid' do |uid|
  response = GitGenerator.create_user_dir(uid)

  case response
  when :user_directory_created
    Response.generic('200', 'User directory created successfully!')
  when :user_directory_exist
    Response.generic('401', 'User directory already exists.')
  end
end

# use a json payload to upload a file
post '/:uid/:project_name' do |uid, project_name|
  request.body.rewind
  payload = JSON.parse(request.body.read)
  response = GitGenerator.create_file_from_payload(uid, project_name, payload)

  case response
  when :file_creation_success
    Response.generic('200', 'File created.')
  when :project_directory_missing
    Response.generic('401', 'Project directory missing.')
  end
end

# deleting a user's directory
delete '/:uid' do |uid|
  response = GitGenerator.delete_user_dir(uid)

  case response
  when :user_deletion_success
    Response.generic('201', 'User directory removed successfully!')
  when :user_missing
    Reponse.generic('401', 'User directory not found.')
  end
end

# deleting a user's project directory
delete '/:uid/:project_name' do |uid, project_name|
  response = GitGenerator.delete_project_dir(uid, project_name)

  case response
  when :project_deletion_success
    Response.generic('201', 'Project directory removed successfully!')
  when :project_missing
    Response.generic('401', 'Project directory not found.')
  end
end

# deleting a user's project's file
delete '/:uid/:project_name/:file_name' do |uid, project_name, file_name|
  response = GitGenerator.delete_file(uid, project_name, file_name)

  case response
  when :file_deletion_success
    Response.generic('201', 'File removed successfully!')
  when :file_missing
    Response.generic('401', 'File not found.')
  end
end

get '/diff/:uid/:file' do |uid, file|
  resp = JSON.parse(GitGenerator.getDif(uid, file))

  case resp['Found']
  when true
    Response.generic('200', resp['sha'])
  when false
    Response.generic('404', 'null')
  end
end

post '/requiredFiles/:uid' do |uid|
  request.body.rewind
  data = JSON.parse(request.body.read)

  resp = GitGenerator.set_required_files(uid, data)
  case resp
  when true
    Response.generic('200', "Updated required files for #{uid}")
  when false
    Response.generic('500', 'Something went wrong')
  end
end

get '/requiredFiles/:uid' do |uid|
  resp = GitGenerator.get_required_files(uid)
  case resp
  when false
    Response.generic('404', "Repo doesn't exist for #{uid}")
  else
    Response.generic('200', resp)
  end
end

get '/checkUploadStatus/:uid' do |uid|
  resp = GitGenerator.required_files_exist?(uid)
  case resp
  when false
    Response.generic('404', "The required files do not exist for UID: #{uid}.")
  else
    Response.generic('200', resp)
  end
end

get '/log/:uid' do |uid|
  resp = GitGenerator.get_log(uid)
  case resp
  when false
    Response.generic('404', "Repo doesn't exist for #{uid}")
  else
    Response.generic('200', resp)
  end
end

# HTTP Response boilerplate
options '*' do
  response.headers['ALLOW'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
end
