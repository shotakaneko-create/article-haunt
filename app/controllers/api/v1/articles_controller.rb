module Api::V1
  class ArticlesController < BaseApiController
    # before_action :set_article, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      articles = Article.where(status: "published").order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer # , include: [ :likes, :comments ]
    end

    def show
      article = Article.where(status: "published").find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def create
      article = current_user.articles.create!(article_params)
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def update
      article = Article.find(params[:id])
      article.update!(article_params)
      render json: article
    end

    def destroy
      article = Article.find(params[:id])
      article.destroy!
    end

    private

      def article_params
        params.require(:article).permit(:title, :body, :status)
      end

    # def set_article
    #   article = Article.find(params[:id])
    # end
  end
end
