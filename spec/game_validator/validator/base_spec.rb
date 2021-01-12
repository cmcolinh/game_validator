# frozen string_literal: true

RSpec.describe GameValidator::Validator::Base do
  describe '#call' do
    let(:non_admin_user, &->{MockUser::new(id: 1, admin?: false)})
    let(:wrong_non_admin_user, &->{MockUser::new(id: 2, admin?: false)})
    let(:admin_user, &->{MockUser::new(id: 1, admin?: true)})
    let(:different_admin_user, &->{MockUser::new(id: 2, admin?: true)})
    let(:validate, &->{GameValidator::Validator::Base::new(
        legal_options: ['run', 'hide'],
        next_player_id: 1)})    

    describe 'when no user is provided' do
      it 'fails if no action is provided' do
        expect(validate.({})).to be_failure
      end

      it 'fails if an invalid player_action is provided' do
        expect(validate.(player_action: 'fight')).to be_failure
      end

      it 'fails if an array of player_actions is provided' do
        expect(validate.(player_action: ['run', 'hide'])).to be_failure
      end
      
      it 'fails even if a valid player_action is provided' do
        expect(validate.(player_action: 'run')).to be_failure
      end
    end

    describe 'when a non-admin user whose turn it is is provided' do
      it 'fails if no action is provided' do
        expect(validate.(user: non_admin_user)).to be_failure
      end

      it 'fails if an invalid player_action is provided' do
        expect(validate.(player_action: 'fight', user: non_admin_user)).to be_failure
      end

      it 'fails if an array of player_actions is provided' do
        expect(validate.(player_action: ['run', 'hide'], user: non_admin_user)).to be_failure
      end

      it 'succeeds if a valid player_action is provided' do
        expect(validate.(player_action: 'run', user: non_admin_user)).to be_success
      end
    end

    describe 'when a non-admin whose turn it is not currently is provided' do
      it 'fails if no action is provided' do
        expect(validate.(user: wrong_non_admin_user)).to be_failure
      end

      it 'fails if an invalid player_action is provided' do
        expect(validate.(player_action: 'fight', user: wrong_non_admin_user)).to be_failure
      end

      it 'fails if an array of player_actions is provided' do
        expect(validate.(player_action: ['run', 'hide'], user: wrong_non_admin_user)).to be_failure
      end
      
      it 'fails even if a valid player_action is provided' do
        expect(validate.(player_action: 'run', user: wrong_non_admin_user)).to be_failure
      end
    end

    describe 'when a admin user whose turn it is is provided' do
      it 'fails if no action is provided' do
        expect(validate.(user: admin_user)).to be_failure
      end

      it 'fails if an invalid player_action is provided' do
        expect(validate.(player_action: 'fight', user: admin_user)).to be_failure
      end

      it 'fails if an array of player_actions is provided' do
        expect(validate.(player_action: ['run', 'hide'], user: admin_user)).to be_failure
      end

      it 'succeeds if a valid player_action is provided' do
        expect(validate.(player_action: 'run', user: admin_user)).to be_success
      end
    end

    describe 'when a admin user other than the one whose turn it is is provided' do
      it 'fails if no action is provided' do
        expect(validate.(user: different_admin_user)).to be_failure
      end

      it 'fails if an invalid player_action is provided' do
        expect(validate.(player_action: 'fight', user: different_admin_user)).to be_failure
      end

      it 'fails if an array of player_actions is provided' do
        expect(validate.(player_action: ['run', 'hide'], user: different_admin_user)).to be_failure
      end

      it 'succeeds if a valid player_action is provided' do
        expect(validate.(player_action: 'run', user: different_admin_user)).to be_success
      end
    end
  end
end
   
