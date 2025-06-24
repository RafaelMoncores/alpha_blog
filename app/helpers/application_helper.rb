module ApplicationHelper
  def gravatar_for(user, options = { size: 200 })
    email_address = user.email.downcase
    hash = Digest::SHA256.hexdigest(email_address)
    size = options[:size]
    default_image = options[:default] || "identicon" # Ou sua URL padrão

    params = URI.encode_www_form("d" => default_image, "s" => size)
    image_src = "https://www.gravatar.com/avatar/#{hash}?#{params}"
    image_tag(image_src, alt: user.username, class: "gravatar rounded shadow mx-auto d-block") # Adicionando uma classe
  end

  # ele vai retornar o usuário atual, se não tiver um, ele faz essa função aí
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # !! converte o valor para booleano
  def logged_in?
    !current_user.nil?
  end
end
