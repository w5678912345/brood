class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
			t.integer	  :role_id,       :null => false
			t.integer 	:note_id,				:null => false
			t.integer 	:gold,					:null => false
			t.integer 	:balance,				:null => false
			t.integer		:total,					:null => false
			t.string 		:pay_type,			:null => false
			t.string		:remark,				:null => true
      t.timestamps
    end
  end
end
