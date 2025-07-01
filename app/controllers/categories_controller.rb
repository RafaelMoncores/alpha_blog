class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end
  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category created successfully."
      redirect_to @category
    else
      render "new"
    end
  end
  def index
    if params[:search]
      # Se houver busca, pagine os resultados da busca
      @categories = Category.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").page(params[:page]).per(3)
    else
      # Caso contrário, pagine todos os artigos
      @categories = Category.paginate(page: params[:page], per_page: 5)
    end
  end
  def show
    @category = Category.find(params[:id])
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
