require "test_helper"

module Pundit
  class MisMatchedTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
    end

    test "get users" do
      _user = User.create(email: "testing 2")

      get special_index_url

      assert_response :success

      assigned_users = assigns(:special_users)

      assert_equal 1, assigned_users.size
      assert_equal @user, assigned_users.first
    end

    test "get user" do
      get special_url(@user)

      assert_response :success

      assigned_user = assigns(:special_user)

      assert_equal @user, assigned_user
    end

    test "new user" do
      assert_raises Pundit::NotAuthorizedError do
        get new_special_url
        assigned_user = assigns(:special_user)

        assert_nil assigned_user
      end
    end

    test "update user" do
      patch special_url(@user), params: {special_user: {email: "new-email"}}
      assert_redirected_to user_url(@user)
    end
  end
end
