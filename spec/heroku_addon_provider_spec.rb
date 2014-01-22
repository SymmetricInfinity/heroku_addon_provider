require 'spec_helper'

describe HerokuAddonProvider do

  before do
    HerokuAddonProvider.manifest_path = 'spec/fixtures/addon-manifest.json'
  end

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
