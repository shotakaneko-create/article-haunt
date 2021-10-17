require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article) }
    let!(:article2) { create(:article, updated_at: 1.days.ago) }
    let!(:article3) { create(:article, updated_at: 2.days.ago) }

    it "記事の一覧が取得できる" do
      aggregate_failures "最後まで通過" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.map {|date| date["id"] }).to eq [article1.id, article2.id, article3.id]
        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した記事が存在するとき" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "その記事のレコードが取得できる" do
        subject

        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"]["name"]).to eq article.user.name
        expect(res["user"]["email"]).to eq article.user.email
      end
    end

    context "指定した記事が存在しないとき" do
      let(:article_id) { 10000 }

      it "そのレコードが取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    context "適切なパラメーターを送信したとき" do
      let(:current_user) { create(:user) }
      let(:params) do
        { article: attributes_for(:article) }
      end
      let(:headers) { current_user.create_new_auth_token }

      it "記事が作成される" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /article/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) do
      { article: { title: Faker::Food.sushi, created_at: 1.day.ago } }
    end
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分の記事を更新しようとした時(適切なパラメーターを送信）" do
      let(:article) { create(:article, user: current_user) }

      it "任意の記事のレコードを更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              not_change { article.reload.body } &
                              not_change { article.reload.created_at }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "自分以外の記事を更新しようした時" do
      let(:article) { create(:article, user: user1) }
      let(:user1) { create(:user) }

      it "任意の記事を更新できない" do
        expect { subject }.to not_change { article1 }
      end
    end
  end

  describe "DELETE /article:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分の記事を削除しようとした時" do
      let!(:article) { create(:article, user: current_user) }
      let(:article_id) { article.id }

      it "記事のレコードを削除できる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "自分以外の記事を削除しようとした時" do
      let(:article1) { create(:article, user: user1) }
      let(:user1) { create(:user) }
      let(:article_id) { article1.id }
      it "記事のレコードを削除できない" do
        expect { subject }.to change { Article.count }.by(0)
      end
    end
  end
end
