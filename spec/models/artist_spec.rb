require 'spec_helper'
require 'pry'

describe Artist do

  it "has a name attribute" do
    artist = Artist.new(:name => "Beatles")
    expect(artist.name).to eq "Beatles"
  end

  it "has many users" do
    artist = Artist.create(:name => "Beatles")
    user_one = User.create(:username => "Rivien")
    user_two = User.create(:username => "Livien")
    user_artist_one = UserArtist.create(:user_id => user_one.id, :artist_id => artist.id)
    user_artist_two = UserArtist.create(:user_id => user_two.id, :artist_id => artist.id)
    
    expect(artist.users).to be_an Array
    expect(artist.users.size).to eq 2
    expect(artist.users).to include user_one
    expect(artist.users).to include user_two
  end
  
end
