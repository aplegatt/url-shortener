require 'sinatra'
require 'yaml/store'
require 'sequel'
require 'sqlite3'
require 'securerandom'

DB = Sequel.sqlite('short_urls.db')

unless DB.tables.include?(:urls)
  DB.create_table :urls do
    primary_key :id
    String :long_url, null: false
    String :short_url, null: false
  end
end

urls = DB[:urls]

get '/' do
  erb :index
end

post '/shorten' do
  @long_url = params['url']
  @short_url = SecureRandom.base64(6)

  urls.insert(long_url: @long_url, short_url: @short_url)

  erb :shorten
end

get '/debug_saved_urls' do
  @urls = urls.all
  erb :urls
end

get '/:short_url' do
  @url = urls.where(short_url: params[:short_url])
  if @url.empty?
    erb :not_found, layout: false
  else
    erb :redirect
    redirect to(@url.first[:long_url])
  end
end

not_found do
  erb :not_found, layout: false
end
