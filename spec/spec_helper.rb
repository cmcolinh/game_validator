# frozen string_literal: true

require 'bundler/setup'
require 'game_validator'
require 'method_call_count'

class MockValidationResult
  def initialize(options = {})
    @result = options
    @success = options[:success?]
  end
  def result;@result.dup;end
  def success?;@success;end
  def failure?;!success?;end
  def inspect;result;end
end

class MockUser
  def initialize(options = {})
    @id = options[:id]
    @admin = options[:admin?]
  end
  def id;@id;end
  def admin?;@admin;end
end

MethodCallCount.enable(MethodCallCount::CallableStub)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
