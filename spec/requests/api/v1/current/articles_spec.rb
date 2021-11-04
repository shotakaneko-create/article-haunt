require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET  /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    let!(:article1) { create(:article, :published, user: current_user) }
    let!(:article2) { create(:article, :published, updated_at: 1.days.ago, user: current_user) }
    let!(:article3) { create(:article, :published, updated_at: 2.days.ago, user: current_user) }

    before { create(:article, :draft) }

    it "自分の書いた記事一覧を参照できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res.map {|date| date["id"] }).to eq [article1.id, article2.id, article3.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "status", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status(:ok)
    end
  end
end
