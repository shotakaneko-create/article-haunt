require 'rails_helper'

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /index" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let!(:current_user) { create(:user) }
    let!(:article1) { create(:article, :draft, user: current_user) }
    let!(:article2) { create(:article, :draft, updated_at: 1.days.ago, user: current_user) }
    let!(:article3) { create(:article, :draft, updated_at: 2.days.ago, user: current_user) }
    let(:headers) { current_user.create_new_auth_token }

    before { create(:article, :published) }

    it "記事の一覧を参照できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.map {|date| date["id"]}).to eq [article1.id, article2.id, article3.id]
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "updated_at", "status", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /show" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "指定した記事が存在するとき" do
      let(:article_id) { article.id }

      context "指定した記事が自分の記事であるとき" do
        let(:article) { create(:article, :draft, user: current_user) }

        it "特定の記事を参照できる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"]["name"]).to eq article.user.name
          expect(res["user"]["email"]).to eq article.user.email
          expect(response).to have_http_status(:ok)
        end
      end

      context "対象の記事が他のユーザーが書いた下書きのとき" do
        let(:article) { create(:article, :draft) }

        it "記事を参照できない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
