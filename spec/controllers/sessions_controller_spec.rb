require 'rails_helper'

def api_call(params)
  post '/api/v1/login', params: params
end

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:email) { 'not_a_mail@mail.com' }
  let(:password) { '0101010101' }
  let(:name) { 'JohnDoe' }

  before do
    create(:user, email: email, password: password, password_confirmation: password, name: name)
  end

  describe 'POST /api/v1/sessions' do
    context 'with invaild password' do
      let(:params) { { user: { email: email, password: '1sda' } } }
      it_behaves_like '401'
      it_behaves_like 'json result'
    end
    context 'sign in with valid params' do
      let(:params) { { user: { email: email, password: password } } }
      it_behaves_like 'json result with auth'
    end
  end
end
