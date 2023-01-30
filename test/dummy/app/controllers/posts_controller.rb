class PostsController < ApplicationController
  load_resource model_class: User, parent: true
  load_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to user_posts_url(@user), notice: "Post was successfully destroyed."
  end

  private

  def post_params
    permitted_attributes(Post)
  end
end
