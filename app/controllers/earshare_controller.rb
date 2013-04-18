require 'open-uri'

class EarshareController < ApplicationController

  class UserArtistToPlaycountFetcher
    attr_reader :username
    @@API_base_uri = "http://ws.audioscrobbler.com/2.0/"
    
    def initialize(username)
      @username = username
      @artist_to_playcount_hash = nil
    end
    
    def fetch_top_artists_json
      uri_params = {
      	"method" => "user.gettopartists",
      	"user" => @username,
      	"api_key" => "74cac458c3a4e1a609ec88017afe2be2",
      	"format" => "json",
        "limit" => "150"
      }
      file = open("#{@@API_base_uri}?#{uri_params.to_query}") 
      JSON.load(file.read)['topartists']['artist']
    end

    def artist_to_playcount_hash
      return @artist_to_playcount_hash unless @artist_to_playcount_hash.nil?
      @artist_to_playcount_hash = load_top_artists
    end

    def load_top_artists
      artist_to_playcount_hash = {}
      fetch_top_artists_json.each do |artist_hash|
        artist_to_playcount_hash[artist_hash['name']] = artist_hash['playcount']
      end
      artist_to_playcount_hash
    end
  end

  class UserArtistComparer
    attr_reader :fetcher_one, :fetcher_two

    def initialize(username_one, username_two)
      @fetcher_one = UserArtistToPlaycountFetcher.new(username_one)
      @fetcher_two = UserArtistToPlaycountFetcher.new(username_two)
    end
    
    def find_shared_artists
      shared_artists = {}
      @fetcher_one.artist_to_playcount_hash.each do |key, value|
        shared_artists[key] = [value, @fetcher_two.artist_to_playcount_hash[key]] unless @fetcher_two.artist_to_playcount_hash[key].nil?
      end
      shared_artists
    end

    def return_percent_shared

    end

    def rank_shared_artists
      find_shared_artists.to_a.sort_by do |artist, playcounts|
        playcounts[0].to_i * playcounts[1].to_i
      end.reverse
    end
    
  end  

  def home
  end

  def stats
    @comparer = UserArtistComparer.new('alexaross', 'ivanmalison')
    @one_max = @comparer.find_shared_artists.map {|key, value| value[0].to_i}.max
    @two_max = @comparer.find_shared_artists.map {|key, value| value[1].to_i}.max
  end
end
