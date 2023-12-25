require "test_helper"

module Pundit
  class BasicLoadAndAuthorizeTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
    end

    test "get users" do
      _user = User.create(email: "testing 2")

      get users_url

      assert_response :success

      assigned_users = assigns(:users)

      assert_equal 1, assigned_users.size
      assert_equal @user, assigned_users.first
    end

    test "get user" do
      get user_url(@user)

      assert_response :success

      assigned_user = assigns(:user)

      assert_equal @user, assigned_user
    end

    test "new user" do
      get new_user_url
      assigned_user = assigns(:user)
      refute_nil assigned_user
    end

    test "update user" do
      patch user_url(@user), params: {user: {email: "new-email"}}
      assert_redirected_to user_url(@user)
    end
  end
end
