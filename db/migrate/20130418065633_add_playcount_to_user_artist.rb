class AddPlaycountToUserArtist < ActiveRecord::Migration
  def change
    add_column :user_artists, :playcount, :integer
  end
end
