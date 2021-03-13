# frozen string_literal: true

require 'game_validator/validator/validate_to_action'

RSpec.describe GameValidator::Validator::ValidateToAction do
  describe '#call' do
    let(:get_wrap, &->{->{MethodCallCount::CallableStub::new(->(**args){'yes'})}})
    let(:unsuccessfully_validate, &->{->(a){MockValidationResult::new(
      success?: false,
      player_action: 'do_something')}})    
    let(:successfully_validate, &->{->(a){MockValidationResult::new(
      success?: true,
      player_action: 'do_something')}} )   

    describe "when the validator's operation fails" do
      it 'emits an object that responds true to #failure?' do
        wrap = get_wrap.()
        validate = GameValidator::Validator::ValidateToAction::new(
          validate: unsuccessfully_validate,
          wrap: wrap)
        expect(validate.(input: 'mocked')).to be_failure
      end

      it 'returns the result of calling unsuccessfully_validate' do
        wrap = get_wrap.()
        unsuccessful_validation = unsuccessfully_validate.(input: 'mocked')
        validate = GameValidator::Validator::ValidateToAction::new(
          validate: unsuccessfully_validate,
          wrap: wrap)
        expect(validate.(input: 'mocked').eql?(unsuccessful_validation)).to be true
      end

      it 'does not call @wrap' do
        wrap = get_wrap.()
        validate = GameValidator::Validator::ValidateToAction::new(
          validate: unsuccessfully_validate,
          wrap: wrap)
        validate.(input: 'mocked')
        expect(wrap.times_called[:call]).to eql(0)
      end
    end

    describe "when the validator's operation succeeds" do
      it 'calls @wrap' do
        wrap = get_wrap.()
        validate = GameValidator::Validator::ValidateToAction::new(
          validate: successfully_validate,
          wrap: wrap)
        validate.(input: 'mocked')
        expect(wrap.times_called[:call]).to eql(1)
      end

      it 'returns the result of calling @wrap' do
        wrap = get_wrap.()
        validate = GameValidator::Validator::ValidateToAction::new(
          validate: successfully_validate,
          wrap: wrap)
        expect(validate.(input: 'mocked').call()).to eql('yes')
      end
    end
  end
end

