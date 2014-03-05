get '/' do
  session.clear
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  @user_id = @access_token.params[:user_id]
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  # at this point in the code is where you'll need to create your user account and store the access token
  #erb @access_token.params[:screen_name]
  p @access_token

  @user = User.find_or_create_by_user_id(user_id: @user_id,
  oauth_token: @access_token.token,
  oauth_secret: @access_token.secret)

  session[:user_id] = @user_id

  erb :index
end

get '/tweet?' do

  content = params[:data]

  @user = User.find_by_user_id(session[:user_id])

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_KEY']
    config.consumer_secret = ENV['TWITTER_SECRET']
    config.oauth_token = @user.oauth_token
    config.oauth_token_secret = @user.oauth_secret
  end

  client.update(content)

  if request.xhr?
    erb :_tweet_processed, :layout => false
  else
    redirect to("/")
  end
end

