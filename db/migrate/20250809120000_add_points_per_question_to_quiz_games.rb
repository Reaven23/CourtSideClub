class AddPointsPerQuestionToQuizGames < ActiveRecord::Migration[7.1]
  def change
    add_column :quiz_games, :points_per_question, :integer, null: false, default: 1
    add_column :quiz_games, :description, :text unless column_exists?(:quiz_games, :description)
  end
end
