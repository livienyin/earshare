class Artist < ActiveRecord::Base
  attr_accessible :name
  has_many :user_artists
  has_many :users, :through => :user_artists
end
