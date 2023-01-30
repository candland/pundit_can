require "test_helper"

module Pundit
  class MissingTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
    end

    test "get users" do
      _user = User.create(email: "testing 2")

      assert_raises Pundit::AuthorizationNotPerformedError do
        get missing_index_url

        assert_response :success

        assigned_users = assigns(:users)

        assert_equal 1, assigned_users.size
        assert_equal @user, assigned_users.first
      end
    end

    test "get user" do
      assert_raises Pundit::AuthorizationNotPerformedError do
        get missing_url(@user)

        assert_response :success

        assigned_user = assigns(:user)

        assert_equal @user, assigned_user
      end
    end

    test "new user" do
      assert_raises Pundit::AuthorizationNotPerformedError do
        get new_missing_url
        assigned_user = assigns(:user)

        assert_nil assigned_user
      end
    end

    test "update user" do
      assert_raises Pundit::AuthorizationNotPerformedError do
        patch missing_url(@user), params: {user: {email: "new-email"}}
        assert_redirected_to user_url(@user)
      end
    end
  end
end
