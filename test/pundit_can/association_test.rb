require "test_helper"

module Pundit
  class AssociationTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create(email: "testing")
      @article1 = Article.create(name: "article1", user: @user)
      @article2 = Article.create(name: "article2", user: @user)

      other_user = User.create(email: "other")
      @article3 = Article.create(name: "article3", user: other_user)
    end

    test "get articles with association override" do
      get user_articles_url(@user)

      assert_response :success

      assigned_user = assigns(:user)
      assert_equal @user, assigned_user

      assigned_articles = assigns(:articles)
      assert_equal 2, assigned_articles.size
      assert_equal @article1, assigned_articles.first
      assert_equal @article2, assigned_articles.last
    end

    test "get article with association override" do
      get user_article_url(@user, @article1)

      assert_response :success

      assigned_user = assigns(:user)
      assert_equal @user, assigned_user

      assigned_article = assigns(:article)
      assert_equal @article1, assigned_article
    end
  end
end
