class AddArticleIdToLikes < ActiveRecord::Migration[6.0]
  def change
    add_reference :likes, :article, null: false, foreign_key: true, default: 1
  end
end
