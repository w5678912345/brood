class AddRmsFileToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts ,:rms_file, :boolean, :null => false ,:default => true
  end
end
