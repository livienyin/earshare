class User < ActiveRecord::Base
  attr_accessible :username
  has_many :user_artists
  has_many :artists, :through => :user_artists
  
  def self.refresh_user(username, reload = false)
    user = where(:username => username).first_or_create
    UserArtist.refresh_top_artists(user) if reload or user.user_artists.empty?
    where(:username => username).first
  end

  def artist_to_playcount_hash
    map = {}
    user_artists.each do |user_artist|
      map[user_artist.artist.name] = user_artist.playcount
    end
    map
  end
end
