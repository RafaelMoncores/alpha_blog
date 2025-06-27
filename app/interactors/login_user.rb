class LoginUser
  include Interactor

  def call
    # 1. Busca o usuário pelo email (passado via context.email)
    user = User.find_by(email: context.email.downcase)

    # 2. Tenta autenticar a senha
    if user && user.authenticate(context.password)
      context.user = user # Armazena o usuário autenticado no contexto
      context.session_user_id = user.id # Sinaliza o ID do usuário para a sessão do controller
      context.flash_success = "Logged in successfully"
    else
      # Se a autenticação falhar, marca o contexto como falha
      context.fail!(flash_danger: "Invalid email/password combination")
    end
  end
end
