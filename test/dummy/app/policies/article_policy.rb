# frozen_string_literal: true

class ArticlePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # scope is either the model class (Article) or the parent's association (@user.articles)
      scope.all
    end
  end
end
