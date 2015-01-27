class CreateAccountSessions < ActiveRecord::Migration
  def change
    create_table :account_sessions do |t|
      t.string :account_id

      t.datetime :started_at
      t.string :started_status
      t.datetime :finished_at
      t.boolean :finished
      t.string :finished_status
      t.string :remark

      t.timestamps
    end
  end
end
