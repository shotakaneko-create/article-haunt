class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at, :status # attributes:このクラスは何をパラメータとして受け取るのかを明示→出力する値を設定

  # has_many :likes
  # has_many :comments
  belongs_to :user, serializer: Api::V1::UserSerializer
end
