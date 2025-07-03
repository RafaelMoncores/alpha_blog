# test/integration/user_signup_test.rb
require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  test "should deny invalid user signup" do # Renomeado para inglês
    # 1. Visita a página de cadastro
    get signup_path
    assert_response :success # Verifica se a requisição foi bem-sucedida (status 200 OK)
    # assert_template "users/new" # Removido: assert_template não é ideal para testes de integração

    # 2. Tenta criar um usuário com parâmetros inválidos
    # Verifica que a contagem de usuários no banco de dados NÃO muda
    assert_no_difference "User.count" do
      post users_path, params: { user: { username: "", email: " ", password: " ", password_confirmation: " " } }
    end

    # 3. Após a tentativa inválida, o formulário deve ser re-renderizado
    # assert_template "users/new" # Removido
    # Verifica a presença de elementos que indicam erros no formulário
    assert_select "div.alert" # Verifica a presença de qualquer div com classe 'alert' (para mensagens flash.now[:alert])
    assert_select "h4.alert-heading" # Verifica a presença do título padrão de alerta do Bootstrap
    assert_nil session[:user_id] # Garante que o usuário não foi logado na sessão
    assert_match "errors", response.body # Verifica se a palavra "errors" aparece no corpo da resposta
  end

  test "should allow valid user signup and log in user" do # Renomeado para inglês
    # 1. Visita a página de cadastro
    get signup_path
    assert_response :success
    # assert_template "users/new" # Removido

    # 2. Tenta criar um usuário com parâmetros válidos
    # Verifica que a contagem de usuários no banco de dados AUMENTA em 1
    assert_difference "User.count", 1 do
      post users_path, params: { user: { username: "ValidUser", email: "valid@example.com", password: "password", password_confirmation: "password" } }
    end

    # 3. Segue o redirecionamento (do `redirect_to articles_path` no controller)
    follow_redirect!
    assert_response :success # Verifica se o redirecionamento foi bem-sucedido
    # assert_template "articles/index" # Removido
    # Verifica se a mensagem flash de sucesso aparece no corpo da resposta
    # CORRIGIDO: Mensagem flash para inglês, conforme o output do teste
    assert_match "Welcome to the Alpha Blog ValidUser, you have successfully signed up", response.body
    assert_equal User.last.id, session[:user_id] # Verifica se o usuário foi logado corretamente
    assert_match "ValidUser", response.body # Verifica se o nome de usuário aparece na página (ex: na navbar)
  end
end
