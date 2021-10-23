class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :status # attributes:このクラスは何をパラメータとして受け取るのかを明示→出力する値を設定
  belongs_to :user, serializer: Api::V1::UserSerializer
end
