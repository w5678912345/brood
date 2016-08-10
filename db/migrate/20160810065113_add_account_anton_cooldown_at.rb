class AddAccountAntonCooldownAt < ActiveRecord::Migration
  def change
    add_column :accounts, :anton_normal_at, :DateTime,:default => Time.now
  end
end
