# frozen string_literal: true

RSpec.describe Types::Callable do
  let(:the_answer, &->{42})
  let(:callable_object, &->{Class.new{def call;42;end}.new})
  let(:lambda_object, &->{->{42}})
  describe '.call' do
    it 'succeeds when provided an object with #call method' do
      expect(Types::Callable.(callable_object)).to respond_to(:call)
    end

    it 'returns the expected value' do
      expect(Types::Callable.(callable_object).call).to eq(the_answer)
    end

    it 'succeeds when provided a lambda' do
      expect(Types::Callable.(lambda_object).call).to eq(the_answer)
    end
  end
end

