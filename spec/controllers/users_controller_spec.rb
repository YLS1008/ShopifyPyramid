require 'rails_helper'

def api_call(params)
  post '/api/v1/users', params: params
end

RSpec.describe Api::V1::UsersController, type: :request do
  let(:email) { 'not_a_mail@mail.com' }
  let(:password) { '0101010101' }
  let(:name) { 'JohnDoe' }

  describe 'POST /api/v1/users' do
    context 'sign up with missing params' do
      context 'no password' do
        let(:params) { { user: { email: email, name: name } } }
        it_behaves_like '422'
        it_behaves_like 'json result'
        it_behaves_like 'contains error msg', "Password can't be blank"
      end

      context 'no email' do
        let(:params) { { user: { password: password, name: name } } }
        it_behaves_like '422'
        it_behaves_like 'json result'
        it_behaves_like 'contains error msg', "Email can't be blank and Email can't be blank"
      end

      context 'no user name' do
        let(:params) { { user: { email: email, password: password } } }
        it_behaves_like '422'
        it_behaves_like 'json result'
        it_behaves_like 'contains error msg', "Name can't be blank"
      end

      context 'existing email' do
        let!(:user) { create(:user) }
        let(:params) { { user: { email: user.email, password: password, name: name } } }
        it_behaves_like '422'
        it_behaves_like 'json result'
        it_behaves_like 'contains error msg', 'Email has already been taken and Email has already been taken'

      end
    end

    context 'with valid params' do
      let(:params) { { user: { email: email, password: password, name: name } } }
      it_behaves_like 'json result with auth'
      specify 'should create a user' do
        api_call params
        byebug
        expect(User.last.name).to eq('JohnDoe')
      end
    end
  end

  describe 'POST api/v1/users/invite' do
    let!(:user) { create(:user) }
    it 'invites new user to the pyramid' do
      post('/api/v1/invite', params: { email: 'test@test.com' }.to_json, headers: { 'Accept': 'applicaion/json',  'Content-Type': 'application/json',
                                        'X-Auth-Email': user.email, 'X-Auth-Token': user.authentication_token })

      expect(user.reload.invitations.first.invited_email).to eq('test@test.com')
    end
  end
end

