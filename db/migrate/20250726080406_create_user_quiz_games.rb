class CreateUserQuizGames < ActiveRecord::Migration[7.1]
  def change
    create_table :user_quiz_games do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz_game, null: false, foreign_key: true
      t.integer :score, default: 0
      t.boolean :completed, default: false, null: false
      t.integer :points_earned, default: 0

      t.timestamps
    end

    add_index :user_quiz_games, [:user_id, :completed]
  end
end
