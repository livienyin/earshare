class EarshareController < ApplicationController  

  class UserArtistComparer
    attr_reader :user_one, :user_two
    
    def initialize(username_one, username_two)
      @user_one = User.refresh_user(username_one)
      @user_two = User.refresh_user(username_two)
    end
    
    def find_shared_artists
      shared_artists = {}
      user_two_artist_to_playcount_hash = @user_two.artist_to_playcount_hash
      @user_one.artist_to_playcount_hash.each do |key, value|
        shared_artists[key] = [value, user_two_artist_to_playcount_hash[key]] unless user_two_artist_to_playcount_hash[key].nil?
      end
      shared_artists
    end

    def rank_shared_artists
      find_shared_artists.to_a.sort_by do |artist, playcounts|
        playcounts[0].to_i * playcounts[1].to_i
      end.reverse
    end
  end
  
  def home
    
  end

  def compare
    @comparer = UserArtistComparer.new(params[:user_one], params[:user_two])
    @one_max = @comparer.find_shared_artists.map {|key, value| value[0]}.max
    @two_max = @comparer.find_shared_artists.map {|key, value| value[1]}.max
  end
end
