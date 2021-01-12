# frozen string_literal: true

RSpec.describe GameValidator do
  it 'has a version number' do
    expect(GameValidator::VERSION).not_to be nil
  end
end

