require 'open-uri'

class InvalidUserError < Exception
end

class UserArtist < ActiveRecord::Base
  attr_accessible :user_id, :artist_id, :playcount
  belongs_to :user, :foreign_key => :user_id
  belongs_to :artist, :foreign_key => :artist_id

  @@API_base_uri = "http://ws.audioscrobbler.com/2.0/"
  @@number_of_artists_to_fetch = 150

  def self.fetch_top_artists_json(username)
    uri_params = {
      "method" => "user.gettopartists",
      "user" => username,
      "api_key" => EarshareApp::Application::config.last_fm_api_key,
      "format" => "json",
      "limit" => @@number_of_artists_to_fetch
    }
    file = open("#{@@API_base_uri}?#{uri_params.to_query}") 
    api_json = JSON.load(file.read)
    raise InvalidUserError.new unless api_json["error"].nil?
    api_json['topartists']['artist']
  end

  def self.refresh_top_artists(username)
    begin
      top_artists_for_user = fetch_top_artists_json(username)
    rescue InvalidUserError
      return nil
    end
    user = User.where(:username => username).first_or_create
    return user if top_artists_for_user.nil?
    top_artists_for_user.each do |artist_hash|
      artist = Artist.where(:name => artist_hash['name']).first_or_create
      user_artist = self.where(:artist_id => artist.id, :user_id => user.id).first_or_create
      user_artist.playcount = artist_hash['playcount']
      user_artist.save!
    end
    user
  end
end
