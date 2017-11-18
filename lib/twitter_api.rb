require 'uri'
class TwitterApi
  def self.generate_access_token()
    url='https://api.twitter.com/oauth2/token'
    authorization="Basic "+Base64.encode64(ENV['TWITTER_CONSUMER_KEY']+':'+ENV['TWITTER_CONSUMER_SECRET']).gsub("\n",'')
    begin
      user_info = RestClient.post(url,{grant_type:'client_credentials'},:Authorization => authorization)
      if user_info.code == 200
        Rails.logger.info("Authenticated")
        response_json = JSON.parse(user_info)
        response_json
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info("err.response")
    end
  end

  def self.search_tweets(response_json,q,session)
    url='https://api.twitter.com/1.1/search/tweets.json?q='+q.to_s+"&recent_tweets&count=20"
    url=URI.encode(url)
    authorize="Bearer "+response_json['access_token']
    begin
      get_tweets=RestClient.get(url,:Authorization => authorize)
      results=JSON.parse(get_tweets.body)
      results["statuses"].take(20).collect do |results|
        testimony = Testimony.new
        testimony.session_id=session
        testimony.tweet_id = results["id"]
        testimony.content = results["text"]
        testimony.screen_name = results["user"]["screen_name"]
        testimony.save
      end
    rescue RestClient::ExceptionWithResponse => err
      Rails.logger.info("err.response")
    end

  end
  def self.params(consumer_key)
    params = {
      'oauth_consumer_key' => consumer_key, # Your consumer key
      'oauth_nonce' => generate_nonce, # A random string, see below for function
      'oauth_signature_method' => 'HMAC-SHA1', # How you'll be signing (see later)
      'oauth_timestamp' => Time.now.getutc.to_i.to_s, # Timestamp
      'oauth_version' => '1.0', # oAuth version
      }
  end

  def self.parse_string(str)
    ret = {}
    str.split('&').each do |pair|
      key_and_val = pair.split('=')
      ret[key_and_val[0]] = key_and_val[1]
    end
    ret
  end

  def self.generate_nonce(size=7)
    Base64.encode64(OpenSSL::Random.random_bytes(size)).gsub(/\W/, '')
  end

  def self.signature_base_string(method, uri, params)
    encoded_params = params.sort.collect{ |k, v| url_encode("#{k}=#{v}") }.join('%26')
    method + '&' + url_encode(uri) + '&' + encoded_params
  end

  def self.url_encode(string)
    CGI::escape(string)
  end

  def self.sign(key, base_string)
    digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, key, base_string)
    Base64.encode64(hmac).chomp.gsub(/\n/, '')
  end

  def self.header(params)
    header = "OAuth "
    params.each do |k, v|
      header += "#{k}=\"#{v}\", "
    end
    header.slice(0..-3) # chop off last ", "
  end

  def self.request_data(header, base_uri, method, post_data=nil)
    url = URI.parse(base_uri)
    http = Net::HTTP.new(url.host, 443) # set to 80 if not using HTTPS
    http.use_ssl = true # ignore if not using HTTPS
    if method == 'POST'
      # post_data here should be your encoded POST string, NOT an array
      resp, data = http.post(url.path, post_data, { 'Authorization' => header })
    else
      resp, data = http.get(url.to_s, { 'Authorization' => header })
    end
    resp.body
  end

  def self.generate_request_token()
    access_token ||= ''
    consumer_key = ENV['TWITTER_CONSUMER_KEY'] # Obtainable from your destination site's API admin panel
    consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] # As above
    callback_url = 'http://localhost:3000/index'
    method = 'POST'
    uri = 'https://api.twitter.com/oauth/request_token'
    params = params(consumer_key)
    signing_key = consumer_secret + '&' + access_token
    params['oauth_callback'] = url_encode(callback_url)
    params['oauth_signature'] = url_encode(sign(signing_key , signature_base_string(method, uri, params)))
    @@token_data = parse_string(request_data(header(params), uri, method))
    @@token_data
  end

  def self.get_access_token(auth_token,auth_verifier,auth_token_secret)
    consumer_key = ENV['TWITTER_CONSUMER_KEY']
    consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    callback_url = 'http://localhost:3000/index'
    params = params(consumer_key)
    method = 'POST'
    uri = 'https://api.twitter.com/oauth/request_token'
    base_uri = 'https://api.twitter.com/oauth/access_token'
    params['oauth_token'] = auth_token
    params['oauth_signature'] = url_encode(sign(consumer_secret + '&' + auth_token_secret, signature_base_string(method, uri, params)))
    post_data=URI.encode_www_form({'oauth_verifier'=> auth_verifier})
    data = parse_string(request_data(header(params), base_uri, method, post_data))
    data
  end
end
