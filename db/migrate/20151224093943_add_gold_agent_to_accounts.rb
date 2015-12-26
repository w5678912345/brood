class AddGoldAgentToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :gold_agent_name, :string, :default => ''
    add_column :accounts, :gold_agent_level, :integer,:default => 0
    add_index :accounts,:gold_agent_level
  end
end
