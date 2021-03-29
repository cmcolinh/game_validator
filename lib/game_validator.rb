require 'dry-types'

module Types
  include Dry.Types()
end
callable = Types.Interface(:call)
Types::Callable = Types.Constructor(Method){|value| callable.call(value); value.method(:call)}

require 'game_validator/version'
require 'game_validator/validator'
require 'game_validator/validator/base'
require 'game_validator/validator/result'

module GameValidator
  class Error < StandardError; end
  # Your code goes here...
end
