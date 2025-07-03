class DestroyCategory
  include Interactor

  def call
    if context.category_to_destroy.destroy
      context.flash_notice = "Category was successfully deleted."
    else
      context.fail!(errors: [ "Failed to delete category." ])
    end
  end
end
