require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    #
    class Dlive < OmniAuth::Strategies::OAuth2
      BLANK_PARAMS  = [nil, ''].freeze
      DEFAULT_SCOPE = 'email:read'.freeze

      option :name, 'dlive'

      option :client_options,
             site:          'https://api.dlive.tv',
             authorize_url: 'https://dlive.tv/o/authorize',
             token_url:     'https://dlive.tv/o/token'

      option :access_token_options,
             header_format: '%s',
             param_name:    'access_token'

      option :authorize_options, [:scope]

      uid { raw_info['username'] }

      info do
        {
          name:        raw_info['username'],
          displayname: raw_info['displayname'],
          email:       raw_info['private']['email'],
          image:       raw_info['avatar']
        }
      end

      extra do
        {
            raw_info: raw_info
        }
      end

      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |key|
            val = request.params[key.to_s]
            params[key] = val unless BLANK_PARAMS.include? val
          end
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      def build_access_token
        options.token_params.merge!(:headers => {'Authorization' => basic_auth_header })
        super.tap do |token|
          token.options.merge!(access_token_options)
        end
      end

      def basic_auth_header
        "Basic " + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
      end

      def callback_url
        return options[:redirect_url] if options.key? :redirect_url
        full_host + script_name + callback_path
      end

      def raw_info
        @raw_info ||= access_token.get("/?#{info_options}").parsed.fetch("data").fetch("me") || {}
      end

      def info_options
        "query=query{me{username displayname avatar private{email}}}"
      end

    end # Dlive
  end # Strategies
end # OmniAuth
