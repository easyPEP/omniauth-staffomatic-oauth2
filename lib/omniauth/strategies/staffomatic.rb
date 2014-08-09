require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Staffomatic < OmniAuth::Strategies::OAuth2
      option :name, :staffomatic

      option :client_options, {
        authorize_url: '/api/v3/oauth/authorize',
        token_url: '/api/v3/oauth/token'
      }

      option :callback_url
      option :provider_ignores_state, true
      option :staffomatic_domain, 'staffomatic.com'
      option :easypep_domain,     'easypep.de'
      option :development_domain, 'staffomatic-api.dev'

      uid do
        raw_info["id"]
      end

      info do
        {
          email: raw_info["email"],
          name: raw_info["full_name"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v3/user').parsed["users"].try(:first)
      end

      def valid_site?
        !!(/\A(https|http)\:\/\/[a-zA-Z0-9][a-zA-Z0-9\-]*\.(#{Regexp.quote(options[:development_domain])}|#{Regexp.quote(options[:staffomatic_domain])}|#{Regexp.quote(options[:easypep_domain])})[\/]?\z/ =~ options[:client_options][:site])
      end

      # well, we should do that, but it's hard in dev mode!
      # def fix_https
      #   options[:client_options][:site].gsub!(/\Ahttp\:/, 'https:')
      # end
      # def setup_phase
      #   super
      #   fix_https
      # end

      def request_phase
        if valid_site?
          super
        else
          fail!(:invalid_site)
        end
      end

      def callback_url
        options[:callback_url] || super
      end
    end
  end
end
