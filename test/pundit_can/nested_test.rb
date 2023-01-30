require "test_helper"

module Pundit
  class NestedTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
      @post1 = Post.create(name: "post1", user: @user)
      @post2 = Post.create(name: "post2", user: @user)

      other_user = User.create(email: "other")
      @post3 = Post.create(name: "post3", user: other_user)
    end

    test "get posts" do
      get user_posts_url(@user)

      assert_response :success

      assigned_user = assigns(:user)
      assert_equal @user, assigned_user

      assigned_posts = assigns(:posts)
      assert_equal 2, assigned_posts.size
      assert_equal @post1, assigned_posts.first
      assert_equal @post2, assigned_posts.last
    end

    test "get post" do
      get user_post_url(@user, @post1)

      assert_response :success

      assigned_user = assigns(:user)
      assert_equal @user, assigned_user

      assigned_post = assigns(:post)
      assert_equal @post1, assigned_post
    end

    test "destroy post" do
      assert_raises Pundit::NotAuthorizedError do
        delete user_post_url(@user, @post1)

        assigned_user = assigns(:user)
        assert_nil assigned_user

        assigned_post = assigns(:post)
        assert_nil assigned_post
      end
    end
  end
end
