class CreateVoteCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :vote_campaigns do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active, default: false

      t.timestamps
    end

    add_index :vote_campaigns, :active
    add_index :vote_campaigns, :start_date
    add_index :vote_campaigns, :end_date
  end
end
