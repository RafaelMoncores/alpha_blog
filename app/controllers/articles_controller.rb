class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :require_user, except: [ :index, :show ]
  before_action :require_same_user, only: [ :edit, :update, :destroy ]

  def show
  end

  def index
    if params[:search]
      # Se houver busca, pagine os resultados da busca
      @articles = Article.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").page(params[:page]).per(3)
    else
      # Caso contrário, pagine todos os artigos
      @articles = Article.paginate(page: params[:page], per_page: 3)
    end
  end
  def new
    @article = Article.new
  end
  def edit
  end
  def create
    result = CreateArticle.call(article_params: article_params, current_user: current_user)
    @article = result.article
    if result.success?
      flash[:notice] = "Article was successfully created."
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end
  def update
    if @article.update(article_params) # .save após .update é redundante a menos que você tenha validações ou callbacks específicos
      flash[:notice] = "Article was successfully updated."
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @article.destroy
    flash[:notice] = "Article was successfully deleted."
    redirect_to articles_path
  end
  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own articles."
      redirect_to @article
    end
  end
end
