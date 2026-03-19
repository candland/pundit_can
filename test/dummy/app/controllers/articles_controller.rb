class ArticlesController < ApplicationController
  load_resource model_class: User, parent: true
  load_resource model_class: Article, through: :user, association: :articles

  def index
  end

  def show
  end
end
