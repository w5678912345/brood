class AddInCpoToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :in_cpo , :boolean ,:null=>false, :default => false
  	add_column :accounts, :enabled, :boolean ,:null=>false, :default => true  
  end
end
