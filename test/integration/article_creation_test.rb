# test/integration/article_creation_test.rb
require "test_helper"

class ArticleCreationTest < ActionDispatch::IntegrationTest
  # Setup method is run before each test
  setup do
    # Creates a normal user to simulate login
    @user = User.create(username: "testuser", email: "test@example.com", password: "password", admin: false)
    # Creates some categories to associate with articles
    @category1 = Category.create(name: "Programming")
    @category2 = Category.create(name: "Web Development")
  end

  # Helper to simulate user login in integration tests
  # This simulates submitting the login form
  def sign_in_as(user)
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  test "should deny article creation if user is not logged in" do # Renomeado para inglês
    # 1. Tries to access the article creation page without being logged in
    get new_article_path
    # Should be redirected to the login page
    assert_redirected_to login_path
    follow_redirect! # Follows the redirect
    # Verifies the exact alert message in the response body
    assert_match "You must be logged in to access this section.", response.body

    # 2. Tries to submit the article creation form without being logged in
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: "New Article", description: "This is a new article.", category_ids: [ @category1.id ] } }
    end
    # Should be redirected again to the login page
    assert_redirected_to login_path
    follow_redirect!
    # Verifies the exact alert message in the response body
    assert_match "You must be logged in to access this section.", response.body
  end

  test "should deny invalid article creation by a logged in user" do # Renomeado para inglês
    sign_in_as(@user) # Logs in the user created in setup
    get new_article_path # Visits the article creation page
    assert_response :success
    # assert_template "articles/new" # Removed

    # Tries to create an article with invalid parameters (empty title and description)
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: "", description: "", category_ids: [] } }
    end

    # Should re-render the 'new' template with errors
    # assert_template "articles/new" # Removed
    assert_select "div.alert" # Verifies the presence of error messages
    assert_select "h4.alert-heading" # Verifies the alert heading
    assert_match "errors", response.body # Verifies if the word "errors" appears in the response body
  end

  test "should allow valid article creation by a logged in user" do # Renomeado para inglês
    sign_in_as(@user) # Logs in the user
    get new_article_path # Visits the article creation page
    assert_response :success
    # assert_template "articles/new" # Removed

    # Tries to create an article with valid parameters and associate categories
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "My Awesome Article", description: "This is a truly awesome article about Ruby on Rails.", category_ids: [ @category1.id, @category2.id ] } }
    end

    # Gets the newly created article for verifications
    article = Article.last
    assert_equal @user, article.user # Verifies if the article was associated with the correct user
    assert_equal 2, article.categories.count # Verifies if the categories were associated
    assert article.categories.include?(@category1)
    assert article.categories.include?(@category2)

    # Follows the redirect to the article's show page
    follow_redirect!
    assert_response :success
    # assert_template "articles/show" # Removed
    # Verifies the success flash message in the response body
    assert_match "Article was successfully created.", response.body

    # Verifies the content on the created article's page
    assert_match "My Awesome Article", response.body
    assert_match "This is a truly awesome article about Ruby on Rails.", response.body
    assert_match @category1.name, response.body # Verifies if the category name appears on the page
    assert_match @category2.name, response.body
  end
end
