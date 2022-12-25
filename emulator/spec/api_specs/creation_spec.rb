require 'rspec'
require 'rack/test'
require 'json'
require './main'

RSpec.configure do |config|
    config.include Rack::Test::Methods
end

PATH = "./users"

RSpec.describe 'chathistorydisplayer-api creation end-points' do
    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    user_id = 'spec_test_user'
    project_name = 'spec_test_project'
    file = { :fileName => 'spec_test_file', :fileContents => 'Test file contents.' }

    # creation of user directory, project directory, and file when these do not already exist
    describe 'GET /init/user_id' do
        it 'should return a 201 resource created status code' do
            get "/init/#{user_id}"
            json_response = JSON.parse(last_response.body)
            expect(json_response['Code']).to eq('201')
        end

        it 'should find a directory' do
            expect(File.exist?("#{PATH}/#{user_id}")).to be_truthy
        end
    end

    describe 'GET /init/user_id/project_name' do
        it 'should return a 201 resource created status code' do
            get "/init/#{user_id}/#{project_name}"
            json_response = JSON.parse(last_response.body)
            expect(json_response['Code']).to eq('201')
        end

        it 'should find a directory' do
            expect(File.exist?("#{PATH}/#{user_id}/#{project_name}")).to be_truthy
        end
    end

    describe 'POST /user_id/project_name' do
        it 'should return a 201 resource created status code' do
            json_body = {
                :fileName => file[:fileName],
                :fileContents => file[:fileContents]
            }.to_json

            content_type = { 'CONTENT-TYPE' => 'application/json' }

            post "/#{user_id}/#{project_name}", json_body, content_type
            json_response = JSON.parse(last_response.body)
            expect(json_response['Code']).to eq('201')
        end

        it 'should find a directory' do
            expect(File.exist?("#{PATH}/#{user_id}/#{project_name}/#{file[:fileName]}")).to be_truthy
        end
    end

    # test when the user directory and project directory
    describe 'GET /init/user_id' do
        it 'should return a 404 resource not found status code' do
            # ensure the spec_test_user directory already exists
            get "/init/#{user_id}"

            get "/init/#{user_id}"
            json_response = JSON.parse(last_response.body)
            expect(json_response['Code']).to eq('404')
        end
    end

    describe 'GET /init/user_id/project_name' do
        it 'should return a 404 resource not found status code' do
            # ensure the spec_test_proj directory already exists
            get "/init/#{user_id}/#{project_name}"

            get "/init/#{user_id}/#{project_name}"
            json_response = JSON.parse(last_response.body)
            expect(json_response['Code']).to eq('404')
        end

        it 'should find a file' do
            expect(File.exist?("#{PATH}/#{user_id}/#{project_name}")).to be_truthy
        end
    end

end