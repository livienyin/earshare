require 'open-uri'

class UserArtist < ActiveRecord::Base
  attr_accessible :user_id, :artist_id, :playcount
  belongs_to :user, :foreign_key => :user_id
  belongs_to :artist, :foreign_key => :artist_id

  @@API_base_uri = "http://ws.audioscrobbler.com/2.0/"
  @@number_of_artists_to_fetch = 150

  def self.fetch_top_artists_json(user)
    uri_params = {
      "method" => "user.gettopartists",
      "user" => user.username,
      "api_key" => "74cac458c3a4e1a609ec88017afe2be2",
      "format" => "json",
      "limit" => @@number_of_artists_to_fetch
    }
    file = open("#{@@API_base_uri}?#{uri_params.to_query}") 
    JSON.load(file.read)['topartists']['artist']
  end

  def self.refresh_top_artists(user)
    fetch_top_artists_json(user).each do |artist_hash|
      artist = Artist.where(:name => artist_hash['name']).first_or_create
      user_artist = self.where(:artist_id => artist.id, :user_id => user.id).first_or_create
      user_artist.playcount = artist_hash['playcount']
      user_artist.save!
    end
    user
  end
end
