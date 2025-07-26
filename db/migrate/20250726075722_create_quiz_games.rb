class CreateQuizGames < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_games do |t|
      t.string :title, null: false
      t.text :description
      t.integer :score, null: false
      t.integer :points, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
