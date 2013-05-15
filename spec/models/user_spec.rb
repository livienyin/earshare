require 'spec_helper'
require 'pry'

describe User do

  let(:user) do
    User.create(:username => "Livien")
  end

  let!(:artist_one) do
    Artist.create(:name => "Beatles")
  end

  let!(:artist_two) do
    Artist.create(:name => "Tom Waits")
  end

  let!(:user_artist_one) do
    UserArtist.create(:user_id => user.id, :artist_id => artist_one.id, :playcount => 5)
  end

  let!(:user_artist_two) do
    UserArtist.create(:user_id => user.id, :artist_id => artist_two.id, :playcount => 10)
  end
  
  it "has a username attribute" do
    expect(user.username).to eq "Livien"
  end

  it "has many artists" do
    expect(user.artists).to be_an Array
    expect(user.artists.size).to eq 2
    expect(user.artists).to include artist_one
    expect(user.artists).to include artist_two
  end

  it "has many user artists" do
    expect(user.user_artists).to be_an Array
    expect(user.user_artists.size).to eq 2
    expect(user.user_artists).to include user_artist_one
    expect(user.user_artists).to include user_artist_two
  end

  it "makes a playcount hash" do
    expect(user.artist_to_playcount_hash).to be_a Hash
    user.artist_to_playcount_hash.should == {"Beatles" => 5, "Tom Waits" => 10}
  end

  it "calls to the last fm api and gets friends" do
    file_double = double(File)
    user.should_receive(:open)
    file_double.stub!(:read).and_return('{"friends": {"user": ["Dave"]}}')
    user.stub!(:open).and_return(file_double)
    
    user.fetch_friends.should == ["Dave"]
  end
end
