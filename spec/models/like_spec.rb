# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_article_id  (article_id)
#  index_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Like, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
