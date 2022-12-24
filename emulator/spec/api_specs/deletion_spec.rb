require 'rspec'
require 'rack/test'
require 'json'
require './main'

RSpec.configure do |config|
    config.include Rack::Test::Methods
end

RSpec.describe 'chathistorydisplayer-api deletion end-points' do
    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    user_id = 'spec_test_user'
    project_name = 'spec_test_project'
    file = { :fileName => 'spec_test_file', :fileContents => 'Test file contents.' }

    describe 'DELETE /user_id/project_name/file' do
        it 'should return a 201 status code' do
            # create the user directory
            get "/init/#{user_id}"

            # create the project directory
            get "/init/#{user_id}/#{project_name}"
            
            # create the file
            json_body = {
                :fileName => file[:fileName],
                :fileContents => file[:fileContents]
            }.to_json

            content_type = { 'CONTENT-TYPE' => 'application/json' }

            post "/#{user_id}/#{project_name}", json_body, content_type

            # delete the file
            delete "/#{user_id}/#{project_name}/#{file[:fileName]}"
        end

        it 'should not find the file' do
            expect(File.exist?("#{PATH}/#{user_id}/#{project_name}/#{file[:fileName]}")).to be_falsy
        end
    end

    describe 'DELETE /user_id/project_name' do
        it 'should return a 201 status code' do
            # create the user directory
            get "/init/#{user_id}"

            # create the project directory
            get "/init/#{user_id}/#{project_name}"

            delete "/#{user_id}/#{project_name}"
        end

        it 'should not find the directory' do
            expect(File.exist?("#{PATH}/#{user_id}/#{project_name}")).to be_falsy
        end
    end

    describe 'DELETE /user_id' do
        it 'should return a 201 status code' do
            # create the user directory
            get "/init/#{user_id}"
            
            delete "/#{user_id}"
        end

        it 'should not find the directory' do
            expect(File.exist?("#{PATH}/#{user_id}")).to be_falsy
        end
    end

end