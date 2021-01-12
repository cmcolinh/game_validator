# frozen string_literal: true

RSpec.describe GameValidator::Validator do
  describe '#call' do
    let(:non_admin_user, &->{MockUser::new(id: 1, admin?: false)})
    let(:admin_user, &->{MockUser::new(id: 1, admin?: true)})
    let(:action_hash, &->{{player_action: 'run', where: 'somewhere'}})
    let(:get_failing_player_action_and_user_validator, &->{->{
      MethodCallCount::CallableStub::new(
        MockValidationResult::new(
          success?: false,
          player_action: 'run',
          user: non_admin_user))}})
    let(:get_successful_player_action_and_user_validator, &->{->{
      MethodCallCount::CallableStub::new(
        MockValidationResult::new(
          success?: true,
          player_action: 'run',
          user: non_admin_user))}})
    let(:get_full_validator, &->{->{
      {
        ['run', false]  => MethodCallCount::CallableStub::new,
        ['run', true]   => MethodCallCount::CallableStub::new,
        ['hide', false] => MethodCallCount::CallableStub::new,
        ['hide', true]  => MethodCallCount::CallableStub::new
      }
    }})
    let(:action_hash_run, &->{{player_action: 'run', where: 'somewhere'}})
    let(:action_hash_hide, &->{{player_action: 'hide', where: 'somewhere'}})

    it 'fails when :validate_player_action_and_user fails' do
      validate = GameValidator::Validator::new(
        validate_player_action_and_user: get_failing_player_action_and_user_validator.(),
        full_validator_for: get_full_validator.())
      expect(validate.(action_hash: action_hash_run, user: non_admin_user)).to be_failure
    end 

    it 'does not call any of the full validators when :validate_player_action_and_user fails' do
      full_validator = get_full_validator.()
      validate = GameValidator::Validator::new(
        validate_player_action_and_user: get_failing_player_action_and_user_validator.(),
        full_validator_for: full_validator)
      validate.(action_hash: action_hash_run, user: non_admin_user)
      expect(full_validator.values.map{|v| v.called_with[:call] || 0}).to all(eql(0))
    end

    [['run', false], ['run', true], ['hide', false], ['hide', true]].each do |player_action, admin|
      it "calls the correct full validator when player_action is '#{player_action}' and admin is #{admin}" do
        full_validator = get_full_validator.()
        validate = GameValidator::Validator::new(
          validate_player_action_and_user: get_successful_player_action_and_user_validator.(),
          full_validator_for: full_validator)
        validate.(action_hash: {player_action: player_action, where: 'somewhere'}, user: admin ? admin_user : non_admin_user)
        expect(full_validator.find{|k, v| k.eql?([player_action, admin])}.last.times_called[:call]).to eql(1)
      end 

      it "doesn't call any non-applicable full validators when player_action is '#{player_action}' and admin is '#{admin}'" do
        full_validator = get_full_validator.()
        validate = GameValidator::Validator::new(
          validate_player_action_and_user: get_successful_player_action_and_user_validator.(),
          full_validator_for: full_validator)
        validate.(action_hash: {player_action: player_action, where: 'somewhere'}, user: admin ? admin_user : non_admin_user)
        expect(full_validator.select{|k, v| !k.eql?([player_action, admin])}.values.map{|v| v.times_called[:call]}).to all(eql(0))
      end
    end
  end
end

