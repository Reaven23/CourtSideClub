class CreateUserQuestionAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :user_question_answers do |t|
      t.references :user_quiz_game, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.boolean :correct, default: false, null: false
      t.datetime :answered_at

      t.timestamps
    end

    add_index :user_question_answers, [:user_quiz_game_id, :question_id], unique: true, name: 'index_user_question_answers_unique'
  end
end
