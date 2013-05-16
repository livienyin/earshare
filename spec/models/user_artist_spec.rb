require 'spec_helper'
require 'pry'

describe UserArtist do

  it "fetches top artists" do
    username = "Livien"
    file_double = double(File)
    file_double.stub!(:read).and_return('{"topartists": {"artist": ["Beatles"]}}')
    UserArtist.stub!(:open).and_return(file_double)
    UserArtist.fetch_top_artists_json(username).should == ["Beatles"]
  end

  it "raises an InvalidUserError when api call gives errors" do
    username = "Livien"
    file_double = double(File)
    file_double.stub!(:read).and_return('{"error": "error"}')
    UserArtist.stub!(:open).and_return(file_double)
    expect{UserArtist.fetch_top_artists_json(username)}.to raise_error(InvalidUserError)
  end
  
  it "handles InvalidUserError" do
    UserArtist.stub!(:fetch_top_artists_json).and_raise(InvalidUserError.new)
    UserArtist.refresh_top_artists("Livien").should ==  nil
  end

  it "saves user_artists" do
    top_artists_for_user = [{"name" => "Beatles", "playcount" => 24}, {"name" => "Tom Waits", "playcount" => 56}]
    UserArtist.stub!(:fetch_top_artists_json).and_return(top_artists_for_user)
    
    expect(UserArtist.refresh_top_artists("Livien")).to be_a User
    
    user = User.where(:username => "Livien").first
    user.user_artists.map {|user_artist| [user_artist.artist.name, user_artist.playcount]}.should == [["Beatles", 24], ["Tom Waits", 56]]
  end
  
  
end
