require 'spec_helper'

describe HerokuAddonProvider do

  before do
    HerokuAddonProvider.manifest_path = 'spec/fixtures/addon-manifest.json'
  end

  describe 'manifest operations' do
    it 'should return the provider id' do
      HerokuAddonProvider.provider_id.must_equal 'my-heroku-addon'
    end

    it 'should return the password' do
      HerokuAddonProvider.password.must_equal 'this is not a secure password'
    end

    it 'should return the sso salt' do
      HerokuAddonProvider.sso_salt.must_equal 'this is not a secure salt'
    end

    it 'should return a computed sso_token' do
      time = Time.parse('Thu Nov 29 14:33:20 GMT 2001')
      HerokuAddonProvider.sso_token(10, time.to_i).must_equal 'c209b926738298059f642fd260abb87e5029a539'
    end
  end

  describe 'provider api' do
    it 'should return the list of installed applications' do
      apps = HerokuAddonProvider.installed_applications
      apps.length.must_equal 4
      apps.first.keys.must_equal(['callback_url', 'heroku_id', 'plan', 'provider_id'])
    end

    it 'should return the application info' do
      app = HerokuAddonProvider.application_info('app11111111@heroku.com')
      app.keys.must_include('owner_email')
    end
  end

  describe 'class configuration' do
    it 'should set the manifest path' do
      HerokuAddonProvider.configure do |config|
        config.manifest_path = '/path/to/addon-manifest.json'
      end
      HerokuAddonProvider.manifest_path.must_equal '/path/to/addon-manifest.json'
    end

    it 'should read the manifest from Rails.root if Rails is defined' do
      class Rails
        def self.root
          'spec/fixtures/'
        end
      end
      HerokuAddonProvider.manifest['id'].must_equal 'my-heroku-addon'
    end
  end
end
