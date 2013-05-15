require 'spec_helper'

describe Artist do

  it "has a name attribute" do
    artist = Aritst.new(:name => "Beatles")
    expect(artist.name).to eq "Beatles"
  end

  it "has many users" do
    artist = Artist.new(:name => "Beatles")
    user_one = User.new(:username => "Rivien")
    user_two = User.new(:username => "Livien")
    expect(artist.users).to be_an Array
    expect(artist.users.size).to eq 2
    expect(artist.users).to include artist_one
    expect(artist.users).to include artist_two
  end
  
end
