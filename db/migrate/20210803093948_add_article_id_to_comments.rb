class AddArticleIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :article, null: false, foreign_key: true, default: 1
  end
end
