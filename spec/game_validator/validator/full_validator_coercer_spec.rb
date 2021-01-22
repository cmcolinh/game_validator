# frozen string_literal: true

RSpec.describe GameValidator::Validator::FullValidatorCoercer do
  describe '#call' do
    let(:full_validation_coercer, &->{GameValidator::Validator::FullValidatorCoercer::new})
    it 'generates the expected hash when provided properly formed Array keys' do
      hash = {
        ['run', false] => MethodCallCount::CallableStub::new,
        ['run', true] => MethodCallCount::CallableStub::new,
        ['hide', false] => MethodCallCount::CallableStub::new,
        ['hide', true] => MethodCallCount::CallableStub::new}
      expect(full_validation_coercer.call(hash).keys).to contain_exactly(
        ['run', false], ['run', true], ['hide', false], ['hide', true])
    end

    it 'generates the expected hash when provided String keys' do
      hash = {'run' => MethodCallCount::CallableStub::new, 'hide' => MethodCallCount::CallableStub::new}
      expect(full_validation_coercer.call(hash).keys).to contain_exactly(
        ['run', false], ['run', true], ['hide', false], ['hide', true])
    end

    it 'generates the expected hash when provided Hash keys' do
      hash = {run: MethodCallCount::CallableStub::new, hide: MethodCallCount::CallableStub::new}
      expect(full_validation_coercer.call(hash).keys).to contain_exactly(
        ['run', false], ['run', true], ['hide', false], ['hide', true])
    end

    it 'can handle a mix of String and Array keys' do
      hash = {
        'run' => MethodCallCount::CallableStub::new,
        ['hide', false] => MethodCallCount::CallableStub::new,
        ['hide', true] => MethodCallCount::CallableStub::new}
      expect(full_validation_coercer.call(hash).keys).to contain_exactly(
        ['run', false], ['run', true], ['hide', false], ['hide', true])
    end

    it 'throws an error if given an empty String as a key' do
      hash = {'run' => MethodCallCount::CallableStub::new, '' => MethodCallCount::CallableStub::new}
      expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
    end

    it 'throws an error if given a zero length Symbol as a key' do
      hash = {run: MethodCallCount::CallableStub::new, :"" => MethodCallCount::CallableStub::new}
      expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
    end

    it 'throws an error if given a Hash key with no elements' do
      hash = {
        'run' => MethodCallCount::CallableStub::new,
        [] => MethodCallCount::CallableStub::new}
      expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
    end

    it 'throws an error if given a Hash key with one element' do
      hash = {
        'run' => MethodCallCount::CallableStub::new,
        ['hide'] => MethodCallCount::CallableStub::new}
      expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
    end

    it 'throws an error if given a Hash key with three elements' do
      hash = {
        'run' => MethodCallCount::CallableStub::new,
        ['hide', true, false] => MethodCallCount::CallableStub::new}
      expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
    end

    [nil, 'hello', 5].each do |key|
      it "throws an error if given a Hash key with two elements, the second of which is neither true or false, but instead #{key}" do
        hash = {
          'run' => MethodCallCount::CallableStub::new,
          ['hide', key] => MethodCallCount::CallableStub::new}
        expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
      end
    end

    [nil, true, 5].each do |key|
      it "throws an error if given a Hash key with two elements, the first of which is neither a String or Symbol, but instead #{key}" do
        hash = {
          'run' => MethodCallCount::CallableStub::new,
          [key, true] => MethodCallCount::CallableStub::new}
        expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
      end
    end

    it "throws an error if the hash value is not something '#call'able" do
      hash = {'run' => MethodCallCount::CallableStub::new, 'hide' => nil}
      expect{full_validation_coercer.call(hash)}.to raise_error(Dry::Types::ConstraintError)
    end
  end
end

