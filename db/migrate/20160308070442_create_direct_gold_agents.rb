class CreateDirectGoldAgents < ActiveRecord::Migration
  def change
    create_table :direct_gold_agents do |t|
      t.string :server_id
      t.string :role_name
      t.boolean :enable

      t.timestamps
    end
  end
end
