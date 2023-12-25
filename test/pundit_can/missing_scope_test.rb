require "test_helper"

module Pundit
  class MissingScopeTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
    end

    test "get users" do
      assert_raises Pundit::PolicyScopingNotPerformedError do
        get missing_scope_index_url
      end
    end

    test "get user" do
      assert_raises Pundit::PolicyScopingNotPerformedError do
        get missing_scope_url(@user)
      end
    end

    test "edit user" do
      assert_raises Pundit::PolicyScopingNotPerformedError do
        get edit_missing_scope_url(@user)
      end
    end

    test "update user" do
      assert_raises Pundit::PolicyScopingNotPerformedError do
        patch missing_scope_url(@user), params: {user: {email: "new-email"}}
      end
    end

    test "new user" do
      get new_missing_scope_url
      assert_response :success
    end

    test "should create user" do
      assert_difference("User.count") do
        post missing_scope_index_url, params: {user: {email: @user.email, password: @user.password}}
      end

      assert_redirected_to missing_scope_url(User.last)
    end

    test "destroy user" do
      assert_raises Pundit::PolicyScopingNotPerformedError do
        delete missing_scope_url(@user)
      end
    end
  end
end
