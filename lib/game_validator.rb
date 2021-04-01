require 'dry-types'

module Types
  include Dry.Types()
end
callable = Types.Interface(:call)
Types::Callable = Types.Constructor(Method) do |value|
  callable.call(value) # raises Dry::Types::ConstraintError if object doesn't respond to #call
  value.is_a?(Method) || value.is_a?(Proc) ? value : value.method(:call)
end
Types::ArrayOfCallable = Types::Array::of(Types::Callable)
Types::ArrayOfStrictInteger = Types::Array::of(Types::Strict::Integer)
Types::ArrayOfString = Types::Array::of(Types::String)

require 'game_validator/version'
require 'game_validator/validator'
require 'game_validator/validator/base'
require 'game_validator/validator/result'

module GameValidator
  class Error < StandardError; end
  # Your code goes here...
end
