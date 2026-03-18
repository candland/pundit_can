# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # scope is either the model class (Post) or the parent's association (@user.posts)
      scope.all
    end
  end
end
