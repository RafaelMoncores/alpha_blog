class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  def show
  end
  def index
    @articles = Article.all
  end
  def new
    @article = Article.new
  end
  def edit
  end
  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:notice] = "Article was successfully created." # Flash message for successful creation
      redirect_to @article # Redirects to the show action of the article
    else
      render :new, status: :unprocessable_entity # Renders the new template again if save fails
    end
  end
  def update
    @article.update(article_params)
    if @article.save
      flash[:notice] = "Article was successfully updated." # Flash message for successful update
      redirect_to @article# Redirects to the show action of the article
    else
      render :edit, status: :unprocessable_entity # Renders the edit template again if save fails
    end
  end
  def destroy
    @article.destroy
    flash[:notice] = "Article was successfully deleted." # Flash message for successful deletion
    redirect_to articles_path # Redirects to the index action of articles
  end
  def index
    if params[:search]
      @articles = Article.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @articles = Article.all
    end
  end
  private # Private methods are not accessible outside this controller.
  def set_article
    # This method is used to set the @article instance variable for show, edit, and update actions.
    @article = Article.find(params[:id])
  end
  def article_params
    # This method is used to whitelist the parameters for article creation and updating.
    params.require(:article).permit(:title, :description)
  end
end
