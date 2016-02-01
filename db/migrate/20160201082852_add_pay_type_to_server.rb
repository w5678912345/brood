class AddPayTypeToServer < ActiveRecord::Migration
  def change
    add_column :servers, :pay_type, :string,:default => 'MAIL'
  end
end
