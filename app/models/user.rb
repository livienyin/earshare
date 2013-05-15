require 'open-uri'

class User < ActiveRecord::Base
  attr_accessible :username 
  has_many :user_artists
  has_many :artists, :through => :user_artists
  @@API_base_uri = "http://ws.audioscrobbler.com/2.0/"
  
  def self.refresh_user(username, reload = false)
    UserArtist.refresh_top_artists(username) if where(:username => username).empty?
    where(:username => username).first
  end

  def fetch_friends
    uri_params = {
      "method" => "user.getfriends",
      "user" => self.username,
      "api_key" => EarshareApp::Application::config.last_fm_api_key,
      "format" => "json",
    }
    file = open("#{@@API_base_uri}?#{uri_params.to_query}")
    friends = JSON.load(file.read)['friends']['user']
    friends = [friends] if friends.class != Array
    friends
  end

  def artist_to_playcount_hash
    artist_to_playcount_map = {}
    self.user_artists.each do |user_artist|
      artist_to_playcount_map[user_artist.artist.name] = user_artist.playcount
    end
    artist_to_playcount_map
  end
end
