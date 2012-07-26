require "watnow/version"
require "watnow/option_parser"

module Watnow

  def self.init
    options = Watnow::OptParser.parse(ARGV)
  end

end
