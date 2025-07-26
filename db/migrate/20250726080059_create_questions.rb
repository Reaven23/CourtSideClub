class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :quiz_game, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :order, null: false

      t.timestamps
    end

    add_index :questions, [:quiz_game_id, :order], unique: true
  end
end
