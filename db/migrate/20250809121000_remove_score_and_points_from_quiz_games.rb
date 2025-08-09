class RemoveScoreAndPointsFromQuizGames < ActiveRecord::Migration[7.1]
  def up
    remove_column :quiz_games, :score if column_exists?(:quiz_games, :score)
    remove_column :quiz_games, :points if column_exists?(:quiz_games, :points)
  end

  def down
    add_column :quiz_games, :score, :integer, null: false, default: 10 unless column_exists?(:quiz_games, :score)
    add_column :quiz_games, :points, :integer, null: false, default: 10 unless column_exists?(:quiz_games, :points)
  end
end

