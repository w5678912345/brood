# encoding: utf-8
class Task < ActiveRecord::Base
   attr_accessible :user_id, :role_id,:computer_id,:sup_id
   attr_accessible :name,:command,:args,:code,:remark
   attr_accessible :pushed,:pushed_at,:callback,:callback_at,:msg,:success,:account_no

   belongs_to :computer
   belongs_to :role

   belongs_to :sup, :class_name => 'Task', inverse_of: 'subs'
   belongs_to :account, :class_name => 'Account', :foreign_key => 'account_no', :primary_key => 'no'
   has_many :subs, :class_name => 'Task', :foreign_key => :sup_id

   default_scope :order => 'id DESC'

   scope :sup_scope, where(:sup_id => 0)

   # def self.new_by task
   #  return nil unless task
   #  Taks.new(:name=>task.name,:command=>task.command,:args=>task.args,:code=>task.code,:remark=>task.remark,:task_id=>task.id)
   # end

   def new_by_user user_id
        Task.new(:name=>self.name,:command=>self.command,:args=>self.args,:code=>self.code,:remark=>self.remark,:sup_id=>self.id,:user_id=>user_id)
   end


   def new_by_computer cid,user_id
        task = self.new_by_user user_id
        task.computer_id = cid
        return task
   end

   def new_by_role rid,user_id
        task = self.new_by_user user_id
        task.role_id = rid
        return task
   end

   def args_hash
      begin
       return JSON.parse(self.args)
      rescue Exception => ex
       return Hash.new
      end
       
   end
   


     # t.string 	  :user_id,			:null => false
     #  t.integer	  :role_id,			:null => false, :default => 0
     #  t.integer   :computer_id,		:null => false,	:default => 0
     #  t.integer	  :task_id,			:null => false, :default => 0
     #  t.string    :name,		    :null => false
     #  t.string 	  :command,			:null => true
     #  t.string 	  :args,			:null => true
     #  t.string 	  :code,			:null => true
     #  t.string 	  :remark,			:null => true
     #  t.boolean   :callback,		:null => false, :default => false
     #  t.boolean   :pushed,			:null => false,	:default => false
     #  t.datetime  :pushed_at,		:null => true
     #  t.datetime  :executed_at,		:null => true
     #  t.string	  :msg,				:null => true
     #  t.boolean   :success,			:null => false,	:default => false
end
