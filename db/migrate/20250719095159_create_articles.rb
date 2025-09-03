class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.string :tags
      t.string :youtube_embed
      t.string :instagram_embed
      t.datetime :published_at

      t.timestamps
    end

    add_index :articles, :published_at
    add_index :articles, [:user_id, :published_at]
  end
end
