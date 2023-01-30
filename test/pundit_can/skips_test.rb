require "test_helper"

module Pundit
  class SkipsTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
    end

    test "get users" do
      _user = User.create(email: "testing 2")

      get skips_url

      assert_response :success

      assigned_users = assigns(:users)

      assert_equal 2, assigned_users.size
      assert_equal @user, assigned_users.first
    end

    test "get user" do
      get skip_url(@user)

      assert_response :success

      assigned_user = assigns(:user)

      assert_equal @user, assigned_user
    end

    test "update user" do
      patch skip_url(@user), params: {user: {email: "new-email"}}
      assert_redirected_to user_url(@user)
    end
  end
end
