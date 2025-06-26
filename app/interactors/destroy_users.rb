class DestroyUsers
  inclue Interactor

  def call
    user_to_destroy = context.user_to_destroy
    current_user    = context.current_user

    # Tenta destruir o usuário, raro quando falha, mas já existe o caso de falha
    if user_to_destroy.destroy
      # Verifica se o usuário que está sendo destruído é o usuário logado
      if current_user && user_to_destroy == current_user
        context.should_clear_session = true # Sinaliza para o controller limpar a sessão
      end

      context.flash_notice = "Account and all associated articles have been deleted."
    else
      context.fail!(errors: user_to_destroy.errors.full_messages || [ "Failed to delete account." ])
    end
  end
end
