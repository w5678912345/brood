# encoding: utf-8
# 关于note的再一次改进？
class AddBetterToNotes < ActiveRecord::Migration
  def change
  	add_column  :notes,	:sup_id, :integer, :null=> false, :default => 0 #上一级依赖
  	add_column  :notes,	:effective, :boolean, :null => false, :default => true # 有效
  	add_column  :notes,	:ending, :boolean, :null => false, :default => false # 结束
  	add_column  :notes, :success, :boolean, :null => false, :default => false # 成功
  	add_column 	:notes, :hours,	 :float,	:null => false, :default => 0 # 小时数
  	add_column  :notes, :gold,	:integer,	:null => false, :default => 0 # 金币
  	add_column  :notes, :started_at, :datetime, :null => true			  # 开始时间
  	add_column  :notes, :stopped_at, :datetime, :null => true			  # 停止时间
  	add_column  :notes, :success_at, :datetime, :null => true			  # 成功时间
  	add_column  :notes, :target, :string, 		:null => true			  # 目标
  	add_column  :notes, :result, :string,	:null => true				  # 结果
  	add_column  :notes, :opts,	:string,	:null => true				  

  end
end
