class RemoveTagsFromArticles < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :tags, :string
  end
end
