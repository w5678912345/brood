class CreateBotVersions < ActiveRecord::Migration
  def change
    create_table :bot_versions ,{id: false,primary_key: :version}do |t|
      t.string :version
      t.string :game_versions

      t.timestamps
    end
    add_index :bot_versions,:version
  end
end
