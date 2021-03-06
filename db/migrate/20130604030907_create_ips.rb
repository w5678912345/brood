# encoding: utf-8
class CreateIps < ActiveRecord::Migration
  def change
    create_table :ips,:id => false ,:primary_key => 'value' do |t|
      t.string :value,						:null => false , :limit => 15
      t.integer :use_count,					:null => false,  :default =>0
      t.timestamps
    end
    add_index :ips, :value ,unique: true
  end
end
