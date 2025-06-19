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
  def create
    @article = Article.new(params.require(:article).permit(:title, :description))
    if @article.save
      flash[:notice] = "Article was successfully created." # Flash message for successful creation
      redirect_to @article # Redirects to the show action of the article
    else
      render :new, status: :unprocessable_entity # Renders the new template again if save fails
    end
  end
end
