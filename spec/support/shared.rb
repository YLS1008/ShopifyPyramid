RSpec.shared_examples 'json result' do
  specify 'returns JSON' do
    api_call params
    expect { JSON.parse(response.body) }.not_to raise_error
  end
end

RSpec.shared_examples 'json result with auth' do
  specify 'returns JSON' do
    api_call params
    expect { JSON.parse(response.body) }.not_to raise_error
    expect(JSON.parse(response.body)['auth_token']).not_to be nil
  end
end

RSpec.shared_examples '422' do
  specify 'returns 422' do
    api_call params
    expect(response.status).to eq(422)
  end
end

RSpec.shared_examples '400' do
  specify 'returns 400' do
    api_call params
    expect(response.status).to eq(400)
  end
end

RSpec.shared_examples '401' do
  specify 'returns 401' do
    api_call params
    expect(response.status).to eq(401)
  end
end

RSpec.shared_examples 'contains error msg' do |msg|
  specify "error msg is #{msg}" do
    api_call params
    json = JSON.parse(response.body)
    expect(json['error']).to eq(msg)
  end
end

RSpec.shared_examples '200' do
  specify 'returns 200' do
    api_call params
    expect(response.status).to eq(200)
  end
end
