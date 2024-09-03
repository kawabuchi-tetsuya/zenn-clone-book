class Api::V1::Current::ArticlesController < Api::V1::BaseController
  before_action :authenticate_user!

  # GET /api/v1/current/articles
  def index
    articles = current_user.articles.not_unsaved.order(created_at: :desc)
    render json: articles
  end

  # /api/v1/current/articles/:id
  def show
    article = current_user.articles.find(params[:id])
    render json: article
  end

  # POST /api/v1/current/articles
  def create
    unsaved_article = current_user.articles.unsaved.first || current_user.articles.create!(status: :unsaved)
    render json: unsaved_article
  end

  # PUT /api/v1/current/articles/:id
  def update
    article = current_user.articles.find(params[:id])
    article.update!(article_params)
    render json: article
  end

  private

    def article_params
      params.require(:article).permit(:title, :content, :status)
    end
end
