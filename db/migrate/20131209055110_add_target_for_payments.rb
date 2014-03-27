class AddTargetForPayments < ActiveRecord::Migration
  def change
  	add_column  :payments,	:target, :string, :null=> true
  end
end
