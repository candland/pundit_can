class MisMatchedController < ApplicationController
  load_resource instance_name: :special_user,
    model_class: User,
    policy_class: SpecialUserPolicy,
    policy_scope_class: SpecialUserPolicy::Scope

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @special_user = User.new(user_params)

    if @special_user.save
      redirect_to @special_user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @special_user.update(user_params)
      redirect_to @special_user, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @special_user.destroy
    redirect_to specials_url, notice: "User was successfully destroyed."
  end

  private

  def user_params
    permitted_attributes(:special_user)
  end

  def pundit_params_for(record)
    params.require(:special_user)
  end
end
