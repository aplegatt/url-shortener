require_relative '../url_shortener.rb'
require 'rspec'
require 'rack/test'

RSpec.configure do |c|
  c.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end

describe 'Url Shortener app' do
  include Rack::Test::Methods
  urls = DB[:urls]

  def app
    Sinatra::Application
  end

  it 'shows main page' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Input long url that You want to shorten')
  end

  it 'creates shortened url' do
    post '/shorten', { url: 'http://www.some.domain.com/some/long/url/to/shorten' }
    expect(last_response).to be_ok
    expect(urls.order(:id).last[:long_url]).to eq('http://www.some.domain.com/some/long/url/to/shorten')
  end
end
