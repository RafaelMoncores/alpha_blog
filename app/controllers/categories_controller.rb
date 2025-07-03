class CategoriesController < ApplicationController
  # set_category para show, edit, update e destroy
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]
  before_action :require_admin, except: [ :index, :show ]

  def new
    @category = Category.new
  end

  def create
    # Chama o interactor CreateCategory, passando os category_params através do contexto
    result = CreateCategory.call(category_params: category_params)

    if result.success?
      # Se o interactor for um sucesso, aplicamos as mudanças no flash e redirecionamos
      flash[:notice] = result.flash_notice
      redirect_to result.category # O interactor retorna a categoria criada no contexto
    else
      # Se o interactor falhar, pegamos o objeto category (com erros) e as mensagens de erro
      @category = result.category # Pega o objeto category do contexto, que contém os erros e os dados preenchidos
      flash.now[:alert] = result.errors.join(", ") # Mostra as mensagens de erro
      render "new", status: :unprocessable_entity # Renderiza o formulário novamente com status 422
    end
  end

  def edit
    # @category já é definido por set_category
  end

  def update
    # A ação de update não foi solicitada para interactor, então permanece como está.
    # Você pode criar um interactor UpdateCategory se a lógica for complexa no futuro.
    if @category.update(category_params)
      flash[:notice] = "Category name updated successfully"
      redirect_to @category
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def index
    if params[:search]
      # CORRIGIDO: Se houver busca, pagine os resultados da busca pelo campo 'name' da categoria
      @categories = Category.where("name LIKE ?", "%#{params[:search]}%").page(params[:page]).per(3)
    else
      # Caso contrário, pagine todas as categorias
      @categories = Category.paginate(page: params[:page], per_page: 5)
    end
  end

  def show
    @articles = @category.articles.paginate(page: params[:page], per_page: 3)
  end

  def destroy
    # Chama o interactor DestroyCategory, passando a categoria a ser destruída
    result = DestroyCategory.call(category_to_destroy: @category)

    if result.success?
      flash[:notice] = result.flash_notice
      redirect_to categories_path
    else
      flash[:alert] = result.errors.join(", ")
      # Se a destruição falhar, redireciona para a listagem de categorias
      redirect_to categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    if !(logged_in? && current_user.admin?)
      flash[:alert] = "Only admins can perform that action"
      redirect_to categories_path
    end
  end
end
