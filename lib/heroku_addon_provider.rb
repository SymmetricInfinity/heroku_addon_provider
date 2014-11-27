require 'digest'
require 'faraday'
require 'faraday_middleware'
require 'heroku_addon_provider/version'
require 'json'

class HerokuAddonProvider

  class << self

    attr_accessor :manifest_path

    def manifest
      if manifest_path
        @manifest ||= JSON.load(File.read(manifest_path))
      elsif (defined?(Rails) && File.exists?("#{Rails.root}/addon-manifest.json"))
        @manifest ||= JSON.load(File.read("#{Rails.root}/addon-manifest.json"))
      else
        raise 'Addon manifest not found'
      end
    end

    def provider_id
      manifest['id']
    end

    def password
      manifest['api']['password']
    end

    def sso_salt
      manifest['api']['sso_salt']
    end

    def sso_token(user_id, timestamp)
      pre_token = "#{user_id}:#{sso_salt}:#{timestamp}"
      Digest::SHA1.hexdigest(pre_token).to_s
    end

    def installed_applications
      faraday.get('/vendor/apps').body
    end

    def application_info(heroku_id)
      faraday.get("/vendor/apps/#{heroku_id}").body
    end

    def owner_email(heroku_id)
      info = application_info(heroku_id)
      info['owner_email']
    end

    def owner_emails
      installed_applications.map do |app|
        owner_email(app['heroku_id'])
      end
    end

    def update_config(heroku_id, new_config)
      faraday.put("/vendor/apps/#{heroku_id}", {'config' => new_config}.to_json)
    end

    def configure(&block)
      yield self
    end

    private
      def faraday
        Faraday.new(url: 'https://api.heroku.com') do |c|
          c.request  :basic_auth, provider_id, password
          c.response :json, :content_type => /\bjson$/
          c.adapter  Faraday.default_adapter
        end
      end
  end
end

