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
end
