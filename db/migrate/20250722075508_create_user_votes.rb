class CreateUserVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vote_campaign, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_votes, [:user_id, :vote_campaign_id], unique: true, name: 'index_user_votes_unique'
  end
end
