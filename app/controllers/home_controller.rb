class HomeController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  skip_before_filter :verify_authenticity_token

  def index
    @name = params[:name]
  end

  def post
    user_id = params[:user_id]
    name = params[:name].downcase
    text = params[:text].downcase

    respond_with = nil

    if text == 'gg'
      respond_with = 'EZ'
    elsif text =~ /what\s*(are|'re)\s*the\s*odds/
      respond_with = name == 'mason' ? 'Not a chance, Mason.' : [
          'No chance.',
          'About 1% chance.',
          'Maybe 20% chance.',
          'Eh, 50/50.',
          'About 80% chance.',
          'Oh, for sure a 99% chance.',
          'Absolutely 100%.'
      ].sample
    elsif name == 'todd' and text =~ /back\s*me\s*up/ and text =~ /bot/
      respond_with = "He's right, guys"
    end

    if respond_with
      uri = URI.parse('https://api.groupme.com/v3/bots/post')
      header = {'Content-Type' => 'text/json'}
      content = {
          :text => respond_with,
          :bot_id => ENV['GROUPME_BOT_ID']
      }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = content.to_json
      response = http.request(request)

      render :text => respond_with
      return
    end

    render :text => 'No Response Necessary.'
  end

end