class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])
  end
  def index
    @articles = Article.all
  end
  def new
    @article = Article.new
  end
  def edit
    @article = Article.find(params[:id])
  end
  def create
    @article = Article.new(params.require(:article).permit(:title, :description))
    if @article.save
      flash[:notice] = "Article was successfully created." # Flash message for successful creation
      redirect_to @article # Redirects to the show action of the article
    else
      render :new, status: :unprocessable_entity # Renders the new template again if save fails
    end
  end
  def update
    @article = Article.find(params[:id])
    @article.update(params.require(:article).permit(:title, :description))
    if @article.save
      flash[:notice] = "Article was successfully updated." # Flash message for successful update
      redirect_to @article# Redirects to the show action of the article
    else
      render :edit, status: :unprocessable_entity # Renders the edit template again if save fails
    end
  end
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Article was successfully deleted." # Flash message for successful deletion
    redirect_to articles_path # Redirects to the index action of articles
  end
end
