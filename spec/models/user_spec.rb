require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "name, password, email を指定している時" do
    it "ユーザーが作られる" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end

  context "name を指定していない時" do
    it "ユーザーが作成されない" do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors.details[:name][0][:error]).to eq :blank
    end
  end

  context "name が重複している時" do
    fit "ユーザーが作成されない" do
      FactoryBot.create(:user, name: "aaa")
      user = FactoryBot.build(:user, name: "aaa")

      expect(user).to be_invalid
      expect(user.errors.details[:name][0][:error]).to eq :taken
    end
  end

  context "password が指定されていない時" do
    it "ユーザーが作成されない" do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end

  context "email が指定されていない時" do
    it "ユーザーが作成されない" do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :blank
    end
  end

end
