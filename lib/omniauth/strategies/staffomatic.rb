require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Staffomatic < OmniAuth::Strategies::OAuth2
      # Available scopes: content themes products customers orders script_tags shipping
      # read_*  or write_*
      DEFAULT_SCOPE = 'read_users'

      option :client_options, {
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/access_token'
      }

      option :name, :staffomatic

      option :callback_url

      option :provider_ignores_state, true
      option :staffomatic_domain, 'staffomatic.com'

      uid { URI.parse(options[:client_options][:site]).host }

      def valid_site?
        !!(/\A(https|http)\:\/\/[a-zA-Z0-9][a-zA-Z0-9\-]*\.#{Regexp.quote(options[:staffomatic_domain])}[\/]?\z/ =~ options[:client_options][:site])
      end

      def fix_https
        options[:client_options][:site].gsub!(/\Ahttp\:/, 'https:')
      end

      def setup_phase
        super
        fix_https
      end

      def request_phase
        if valid_site?
          super
        else
          fail!(:invalid_site)
        end
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      def callback_url
        options[:callback_url] || super
      end
    end
  end
end
