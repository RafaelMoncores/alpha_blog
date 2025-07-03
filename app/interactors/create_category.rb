class CreateCategory
  include Interactor

  def call
    context.category = Category.new(context.category_params)

    if context.category.save
      context.flash_notice = "Category created successfully."
    else
      context.fail!(errors: context.category.errors.full_messages, category: context.category)
      # 'category: context.category' para garantir que o objeto com erros seja retornado ao controller
    end
  end
end
