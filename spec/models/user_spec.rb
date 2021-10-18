require "rails_helper"

RSpec.describe User, type: :model do
  context "name, password, email を指定している時" do
    let(:user) { FactoryBot.build(:user) }
    it "ユーザーが作られる" do
      aggregate_failures "最後まで通過する" do
        expect(user).to be_valid
      end
    end
  end

  context "name を指定していない時" do
    let(:user) { FactoryBot.build(:user, name: nil) }
    it "ユーザーが作成されない" do
      aggregate_failures "最後まで通過する" do
        expect(user).to be_invalid
        expect(user.errors.details[:name][0][:error]).to eq :blank
      end
    end
  end

  context "password が指定されていない時" do
    let(:user) { FactoryBot.build(:user, password: nil) }
    it "ユーザーが作成されない" do
      aggregate_failures "最後まで通過する" do
        expect(user).to be_invalid
        expect(user.errors.details[:password][0][:error]).to eq :blank
      end
    end
  end

  context "email が指定されていない時" do
    let(:user) { FactoryBot.build(:user, email: nil) }
    it "ユーザーが作成されない" do
      aggregate_failures "最後まで通過する" do
        expect(user).to be_invalid
        expect(user.errors.details[:email][0][:error]).to eq :blank
      end
    end
  end
end
