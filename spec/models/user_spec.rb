require 'spec_helper'

describe User do

  it "has a username attribute" do
    user = User.new(:username => "Livien")
    expect(user.username).to eq "Livien"
  end

  it "has many artists" do
    user = User.new(:username => "Livien")
    artist_one = Artist.new(:name => "Beatles")
    artist_two = Artist.new(:name => "Tom Waits")
    expect(user.artists).to be_an Array
    expect(user.artists.size).to eq 2
    expect(user.artists).to include artist1
    expect(user.artists).to include artist2
  end
  
end
