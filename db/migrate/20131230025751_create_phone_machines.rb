class CreatePhoneMachines < ActiveRecord::Migration
  def change
    create_table :phone_machines do |t|

      t.timestamps
    end
  end
end
