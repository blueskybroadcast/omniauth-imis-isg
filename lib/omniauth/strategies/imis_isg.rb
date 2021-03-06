require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class ImisIsg < OmniAuth::Strategies::OAuth2
      option :name, 'imis_isg'

      option :app_options, { app_event_id: nil }

      option :client_options, { login_page_url: 'MUST_BE_PROVIDED' }

      uid { info[:uid] }

      info { raw_user_info }

      def request_phase
        redirect login_page_url
      end

      def callback_phase
        account = Account.find_by(slug: account_slug)
        app_event = account.app_events.where(id: options.app_options.app_event_id).first_or_create(activity_type: 'sso')
        self.env['omniauth.auth'] = auth_hash
        self.env['omniauth.origin'] = '/' + account_slug
        self.env['omniauth.app_event_id'] = app_event.id
        self.env['omniauth.redirect_url'] = request.params['redirect_url'].presence
        call_app!
      end

      def auth_hash
        AuthHash.new(provider: name, uid: uid, info: info)
      end

      private

      def raw_user_info
        {
          uid: request.params['uid'],
          first_name: request.params['first_name'],
          last_name: request.params['last_name'],
          email: request.params['email'],
          username: request.params['username'],
          access_code: request.params['access_code']
        }
      end

      def login_page_url
        options.client_options.login_page_url
      end

      def account_slug
        request.params['slug']
      end
    end
  end
end
