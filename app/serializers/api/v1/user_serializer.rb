class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email # attributes:このクラスは何をパラメータとして受け取るのかを明示→出力する値を設定
end
