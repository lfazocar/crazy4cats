class AddUniqueArticleIdAndUserIdToReactions < ActiveRecord::Migration[7.0]
  def change
    add_index :reactions, [:article_id, :user_id], unique: true
  end
end
