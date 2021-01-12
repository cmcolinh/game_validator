require 'dry-types'

module Types
  include Dry.Types()
end

require 'game_validator/version'
require 'game_validator/validator'

module GameValidator
  class Error < StandardError; end
  # Your code goes here...
end
