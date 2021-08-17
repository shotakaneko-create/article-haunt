# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  draft      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           default(1), not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "title が30文字以下の時" do
    let(:article) { FactoryBot.build(:article) }
    it "article が作成される" do
      expect(article).to be_valid
    end
  end

  context "title が31文字以上の時" do
    let(:article) { FactoryBot.build(:article, title: "あああああああああああああああああああああああああああああああ", user_id: 1) }
    it "article が作成されない" do
      expect(article).to be_invalid
    end
  end
end
