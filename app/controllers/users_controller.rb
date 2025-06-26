class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :require_user, only: [ :edit, :update ]
  before_action :require_same_user, only: [ :edit, :update, :destroy ]
  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 3)
  end
  def index
    @users = User.paginate(page: params[:page], per_page: 3)
  end
  def new
    @user = User.new
  end
  def create
    # Chama o interactor, passando os user_params através do contexto
    result = CreateUserAndLogin.call(user_params: user_params)

    if result.success?
      # Se o interactor for um sucesso, aplicamos as mudanças na sessão e no flash
      session[:user_id] = result.session[:user_id] # Pega o user_id do contexto
      flash[:notice] = result.flash_notice        # Pega a mensagem de flash do contexto
      redirect_to articles_path
    else
      @user = result.user # Pega o objeto user do contexto, que contém os erros e os dados preenchidos
      flash.now[:alert] = result.errors.join(", ") # Mostra as mensagens de erro
      render "new"
    end
  end

def destroy
  # Chama o interactor, passando o usuário a ser destruído e o usuário logado
  result = DestroyUsers.call(user_to_destroy: @user, current_user: current_user)

  if result.success?
    # Se o interactor sinalizar para limpar a sessão
    session[:user_id] = nil if result.should_clear_session
    flash[:notice] = result.flash_notice
    redirect_to root_path
  else
    flash[:alert] = result.errors.join(", ")
    redirect_to @user # Ou outra página apropriada para lidar com a falha
  end
end

  def edit
  end
  def update
    if @user.update(user_params)
      flash[:notice] = "Your account was updated successfully"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own aaccount."
      redirect_to @user
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
