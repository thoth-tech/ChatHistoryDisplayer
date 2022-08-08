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
#Working directory
$working_dir = Dir.pwd

#Initializing a Git repo
# logger = Logger.new(STDOUT)
# g = Git.init
#     Git.init('test')
#     Git.init("#$working_dir/test",
#         { :repository => "#$working_dir/test/proj.git",
#             :index => "#$working_dir/test/index"} )


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

get '/init' do
    puts "initialising Git repo"
    GitGenerator.init()
end

get '/:uid' do |uid|
    puts 'retrieving Git repo'
    GitGenerator.retrieve(uid)
end

post '/:uid' do |uid|
    puts 'posting a file to ' + uid + " repo"
    file = "fileHERE"
    GitGenerator.postTo(uid, file)
end