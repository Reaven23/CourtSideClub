class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.string :content, null: false
      t.boolean :correct, default: false, null: false
      t.integer :order, null: false

      t.timestamps
    end

    add_index :answers, [:question_id, :order], unique: true
  end
end
