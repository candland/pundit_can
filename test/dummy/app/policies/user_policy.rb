# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    true
  end

  def permitted_attributes
    [:email, :password]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      User.where(id: user.id)
    end
  end
end
