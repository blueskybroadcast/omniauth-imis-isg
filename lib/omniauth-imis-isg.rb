require 'omniauth-imis-isg/version'
require 'omniauth/strategies/imis_isg.rb'

module Omniauth
  module ImisIsg
    OmniAuth.config.add_camelization 'imis_isg', 'ImisIsg'
  end
end
