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
get '/init/:uid' do |uid|
  GitGenerator.init
  resp = GitGenerator.create_user_repo(uid)
  case resp
  when true
    Response.generic('200', "Created a git repo for #{uid}")
  when false
    Response.generic('401', "Repo already exists for #{uid}")
  else
    Response.generic('501', 'Unknown error. Check server logs')
  end
end

get '/:uid' do |uid|
  puts 'Does user repo exist?'
  GitGenerator.user_repo_exists?(uid)
end

# Submit a file for a user
post '/:uid' do |uid|
  puts "posting a file to #{uid} repo"
  request.body.rewind
  data = JSON.parse(request.body.read)
  GitGenerator.postTo(uid, data['fileName'], data['file'], data['commitMsg'])
end

# Delete a file for a user
delete '/:uid' do |uid|
  puts "Deleting repo for #{uid}"
  # Delete code
  Response.generic('200', 'Deleted file')
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
