class CreateArticle
  include Interactor

  def call
    article = Article.new(context.article_params)
    article.user = context.current_user

    if article.save
      context.article = article
    else
      context.fail!(errors: article.errors.full_messages, article: article)
    end
  end
end
