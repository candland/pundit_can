class Article < ApplicationRecord
  self.table_name = "posts"
  belongs_to :user
end
