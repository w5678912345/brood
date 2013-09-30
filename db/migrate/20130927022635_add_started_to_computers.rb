# encoding: utf-8
class AddStartedToComputers < ActiveRecord::Migration
  def change
  	add_column  :computers,	:started, :boolean, :null => false,:default => false
  end
end
