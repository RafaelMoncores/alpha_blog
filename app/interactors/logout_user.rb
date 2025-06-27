class LogoutUser
  include Interactor

  def call
    context.flash_success = "Logged out successfully"
    context.clear_session = true
  end
end
