class User < ApplicationRecord
  has_many :posts
  has_many :articles, class_name: "Article", foreign_key: :user_id
end
