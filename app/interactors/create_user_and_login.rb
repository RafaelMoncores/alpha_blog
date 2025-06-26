class CreateUserAndLogin
  include Interactor

  def call
    user = User.new(context.user_params)      # << Diferença 1 (parte A)

    if user.save                              # << Diferença 1 (parte B)
      context.user = user
      context.session = { user_id: user.id }  # << Diferença 2 (e 3)
      context.flash_notice = "Welcome to the Alpha Blog #{user.username}, you have successfully signed up" # << Diferença 4
    else
      context.fail!(errors: user.errors.full_messages, user: user) # << Diferença 5
    end
  end
end
