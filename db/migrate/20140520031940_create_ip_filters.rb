class CreateIpFilters < ActiveRecord::Migration
  def change
    create_table :ip_filters do |t|
      t.string :regex
      t.boolean :enabled
      t.boolean :reverse

      t.timestamps
    end
  end
end
