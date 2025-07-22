class CreateVoteCampaignPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :vote_campaign_players do |t|
      t.references :vote_campaign, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end

    add_index :vote_campaign_players, [:vote_campaign_id, :player_id], unique: true, name: 'index_vote_campaign_players_unique'
  end
end
