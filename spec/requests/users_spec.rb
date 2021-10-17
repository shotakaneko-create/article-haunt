require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "正しいパラメーターを送った時" do
      let(:params) { attributes_for(:user) }

      it "ユーザーが登録される" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["data"]["email"]).to eq params[:email]
        # expect(res["data"]["password"]).to eq params[:password]
        # パスワードがレスポンスに含まれていないのはなぜ？
        expect(response).to have_http_status(:ok)
        expect(response.has_header?("client")).to eq(true)
        expect(response.has_header?("access-token")).to eq(true)
        expect(response.has_header?("expiry")).to eq(true)
        expect(response.has_header?("token-type")).to eq(true)
        expect(response.has_header?("uid")).to eq(true)
      end
    end

    context "name が送れなかった時" do
      let(:params) { attributes_for(:user, name: nil) }

      it "ユーザーが登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "password が送れなかった時" do
      let(:params) { attributes_for(:user, password: nil) }

      it "password が設定されていないためユーザーが登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "email が送れなかった時" do
      let(:params) { attributes_for(:user, password: nil) }

      it "email が設定されていないためユーザーが登録できない" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "メールアドレス、パスワードが正しい時" do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: current_user.password } }

      it "ログインできる" do
        subject
        expect(response.headers["uid"]).to be_present
        expect(response.headers["expiry"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["token-type"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "メールアドレスが正しくない時" do
      let(:current_user) { create(:user) }
      let(:params) { { email: Faker::Internet.email, password: current_user.password } }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to be_falsey
        expect(res["errors"]).to eq(["Invalid login credentials. Please try again."])
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["expiry"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["token-type"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "パスワードが正しくない時" do
      let(:current_user) { create(:user) }
      let(:params) { { email: current_user.email, password: Faker::Internet.password } }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to be_falsey
        expect(res["errors"]).to eq(["Invalid login credentials. Please try again."])
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["expiry"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["token-type"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ログインしている時" do
      let(:headers) { current_user.create_new_auth_token }
      let(:current_user) { create(:user) }

      it "ログアウトできる" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to be true
        expect(current_user.reload.tokens).to be_blank
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
