require 'spec_helper'

describe User do

  it "has a username attribute" do
    user = User.new(:username => "Livien")
    expect(user.username).to eq "Livien"
  end

  it "has many artists" do
    user = User.create(:username => "Livien")
    artist_one = Artist.create(:name => "Beatles")
    artist_two = Artist.create(:name => "Tom Waits")
    user_artist_one = UserArtist.create(:user_id => user.id, :artist_id => artist_one.id)
    user_artist_two = UserArtist.create(:user_id => user.id, :artist_id => artist_two.id)

    expect(user.artists).to be_an Array
    expect(user.artists.size).to eq 2
    expect(user.artists).to include artist_one
    expect(user.artists).to include artist_two
  end
end
