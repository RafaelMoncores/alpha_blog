class SessionsController < ApplicationController
  def new
  end

  def create
    # Chama o interactor, passando os dados de login
    result = LoginUser.call(email: params[:session][:email], password: params[:session][:password])

    if result.success?
      session[:user_id] = result.session_user_id # Pega o ID do usuário para a sessão
      flash[:success] = result.flash_success
      redirect_to result.user # Redireciona para o usuário (result.user precisa ser definido no interactor)
    else
      flash.now[:danger] = result.flash_danger # Pega a mensagem de erro do interactor
      render "new"
    end
  end

  def destroy
    result = LogoutUser.call

    if result.success? # LogoutUser sempre será sucesso, a menos que você adicione falhas
      session[:user_id] = nil if result.clear_session # Limpa a sessão se o interactor sinalizar
      flash[:success] = result.flash_success
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong during logout."
      redirect_to root_path
    end
  end
end
