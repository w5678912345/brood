# encoding: utf-8
class DataNode < ActiveRecord::Base
  # attr_accessible :title, :body

   attr_accessible :computers, :accounts, :roles, :events, :opts,:source,:data,:marked_at

    scope :date_scope,lambda{|start_date,end_date|where(marked_at: start_date.at_beginning_of_day..end_date.end_of_day)}

   # scope :markat_scope,lambda{|start_date,end_date|where(created_at: start_date.at_beginning_of_day..end_date.end_of_day)}


   def self.mark
   		records = Account.select("count(id) as accounts_count, status").reorder("status").group("status")
   		h = {}
   		records.each do |record|
   			h[record.status] = record.accounts_count
   		end
   		DataNode.create(:data => h.to_s,:source=>"accounts",:marked_at=>Time.now)
   end


  def self.mark_notes date
    records = Note.select("count(id) as notes_count,api_name").group("api_name").reorder("api_name").where("date(created_at)=?",date)
    h = {}
    records.each do |record|
      h[record.api_name] = record.notes_count
    end
    DataNode.create(:data=>h.to_s,:source=>"notes",:marked_at=>date)
  end

  def data_hash
    return eval(self.data)
  end

  def self.mark_notes_yesterday
    DataNode.mark_notes(Date.today.ago(1.day).strftime("%Y-%m-%d") )
  end

  def self.mark_notes_history
    (Date.new(2014, 12, 20)..Date.new(2015, 01, 12)).each do |date|
      DataNode.mark_notes(date.strftime("%Y-%m-%d"))
    end
  end


  #DataNode.update_all("data=accounts,source='accounts',marked_at=created_at")

end
