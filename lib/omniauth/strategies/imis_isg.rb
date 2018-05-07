require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class ImisIsg < OmniAuth::Strategies::OAuth2
      option :name, 'imis_isg'
    end
  end
end
