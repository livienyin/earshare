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
      @user_one.artist_to_playcount_hash.each do |artist, play_count|
        shared_artists[artist] = [play_count, user_two_artist_to_playcount_hash[artist]] unless user_two_artist_to_playcount_hash[artist].nil?
      end
      shared_artists
    end

    def rank_shared_artists
      find_shared_artists.to_a.sort_by do |artist, playcounts|
        -(playcounts[0].to_i * playcounts[1].to_i)
      end
    end
  end
  
  def home
  end

  def search
    redirect_to( '/' + params[:username])
  end

  def show_user
    @user = User.refresh_user(params[:username])
    return if @user.nil?
    @user_friends = @user.fetch_friends
    @user_friends = @user_friends.sort_by do |friend_hash|
      friend_hash['shared_artists'] = UserArtistComparer.new(@user.username, friend_hash['name']).find_shared_artists.count
    end
  end

  def compare
    @username = params[:user_one]
    @comparer = UserArtistComparer.new(params[:user_one], params[:user_two])
    @one_max = @comparer.find_shared_artists.map {|key, value| value[0]}.max
    @two_max = @comparer.find_shared_artists.map {|key, value| value[1]}.max
  end

  def comment_form
    # @username = params[:username]
  end


  def send_comments
    # @username = params[:username]
    @subject = params[:subject]
    EarshareMailer.form_email(params[:from], @subject, params[:body]).deliver
  end
end
