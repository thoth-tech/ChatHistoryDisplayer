#Gems 
require "rubygems"
require "git"
require "dir"
require "logger"
require "sinatra"
require "json"

#User defined classes/Gems
require "./generator.rb"
require "./util.rb"

#Initializing a Git repo
# logger = Logger.new(STDOUT)



# HTTP Response boilerplate
before do
    content_type :json
end

# REST API METHODS HERE
get '/test' do
    # Have coded it to return true. Will use this as our positive outcome scenario
    outcome = GitGenerator.test() 

    # Determine what response the server gives based on that outcome
    case outcome
    # Positive result
    when true
        Response.generic("200", "Positive outcome")
    # Negative result
    when false
        Response.generic("500", "Negative outcome")
    # Unknown result
    else 
        Response.generic("501", "Unknown outcome")
    end

end

get '/init/:uid' do |uid|
    resp = GitGenerator.init(uid)
    case resp
    when true
        Response.generic("200", "Created a git repo for #{uid}")
    when false 
        Response.generic("401", "Repo already exists for #{uid}")
    else 
        Response.generic("501", "Unknown error. Check server logs")
    end
end

get '/:uid' do |uid|
    puts 'retrieving Git repo'
    GitGenerator.retrieve(uid)
end

post '/:uid' do |uid|
    puts 'posting a file to ' + uid + " repo"
    request.body.rewind
    data = JSON.parse(request.body.read)
    GitGenerator.postTo(uid, data["file"], data["commitMsg"])
end

delete '/:uid' do |uid|
    puts 'Deleting repo for ' + uid
    # Delete code
    Response.generic("200", "Deleted file")
end

get '/diff/:uid/:file' do |uid, file|
    resp = JSON.parse(GitGenerator.getDif(uid, file))
    
    case resp["Found"]
    when true
        Response.generic("200", resp["sha"])
    when false
        Response.generic("404", "null")
    end
end
