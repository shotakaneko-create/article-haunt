class AddUserIdToLikes < ActiveRecord::Migration[6.0]
  def change
    add_reference :likes, :user, null: false, foreign_key: true, default: 1
  end
end
