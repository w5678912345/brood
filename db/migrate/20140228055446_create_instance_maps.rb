class CreateInstanceMaps < ActiveRecord::Migration
  def change
    create_table :instance_maps do |t|
      t.integer :key, :null => false
      t.string :name, :null => false, :limit => 64
      t.integer :min_level, :null => false #最小等级
      t.integer :max_level, :null => false #最大等级
      t.integer :gold,      :null => false, :default => 0 #金币
      t.integer :exp,       :null => false, :default => 0 #经验
      t.boolean :enabled,   :null => false, :default => true #是否启用
      t.integer :safety_limit, :null => false #安全限制
      t.integer :death_limit,  :null => false #死亡限制
      t.integer :enter_count,  :null => false, :default => 0 #进入角色数量
      t.string :remark, :limit => 128 #备注
      t.timestamps
    end

    #add_index :instance_maps, :key , :unique => true
  end
end
