require 'minitest/spec'
require 'minitest/autorun'
require 'heroku_addon_provider'

class HerokuAddonProvider
  def self.faraday
    Faraday::Connection.new do |c|
      c.use Faraday::Adapter::Test do |stub|
        stub.get '/vendor/apps' do
          [200, {}, File.read('spec/fixtures/installed_applications.json')]
        end
        stub.get '/vendor/apps/app11111111@heroku.com' do
          [200, {}, File.read('spec/fixtures/application_info.json')]
        end
      end
      c.response :json
    end
  end
end

