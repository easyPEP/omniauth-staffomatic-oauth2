require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Staffomatic < OmniAuth::Strategies::OAuth2
      option :name, :staffomatic

      option :client_options, {
        authorize_url: '/oauth/authorize', # redirect the user
        token_url: '/v3/oauth/token' # api request to get user token.
      }

      option :callback_url
      option :provider_ignores_state, true
      option :staffomatic_domain, 'staffomaticapp.com'
      option :easypep_domain,     'staffomaticapp.com'
      option :development_domain, 'staffomatic-api.dev'

      uid do
        raw_info["id"]
      end

      info do
        {
          email: raw_info["email"],
          name: "#{raw_info['first_name']} #{raw_info['last_name']}"
        }
      end

      def raw_info
        @raw_info ||= access_token.get(api_path('user')).parsed
        @raw_info
      end

      # should return a proper API path including account subdomain
      # e.g.: /v3/demo/user.json
      def api_path(path)
        "/v3/#{account_subdomain}/#{path}.json"
      end

      def account_subdomain
        host = URI.parse(options[:client_options][:site]).host
        subdomain = host.remove(".#{options[:development_domain]}").remove(".#{options[:staffomatic_domain]}").remove(".#{options[:easypep_domain]}")
        subdomain
      end

      def valid_site?
        !!(/\A(https|http)\:\/\/[a-zA-Z0-9][a-zA-Z0-9\-]*\.(#{Regexp.quote(options[:development_domain])}|#{Regexp.quote(options[:staffomatic_domain])}|#{Regexp.quote(options[:easypep_domain])})[\/]?\z/ =~ options[:client_options][:site])
      end

      def fix_https
        options[:client_options][:site].gsub!(/\Ahttp\:/, 'https:')
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
