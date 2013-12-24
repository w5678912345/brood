class Sheet < ActiveRecord::Base
  require 'roo'

  attr_accessible :remark,:file,:imported,:imported_at,:import_count

  belongs_to :uploader, :class_name => 'User'
  belongs_to :importer, :class_name => 'User'

  mount_uploader :file, FileUploader


  def open_excel_file(filename)
    ex = case filename[/\.[^\.]+$/]
    when ".xlsx" then  Roo::Excelx.new(filename) 
    when ".xls" then Roo::Excel.new(filename) 
    end
    ex.sheet(0)
    ex
  end


  def import
  	 filename = "#{Rails.root}/public/#{self.file.to_s}"
  	 excel = self.open_excel_file(filename)
     #
     excel.default_sheet = excel.sheets.first
     count = 0
     2.upto excel.last_row do |i|
   		account = excel.cell(i,'A').to_i
   		password = excel.cell(i,'B')
   		role_index = excel.cell(i,'C').to_i
   		server = excel.cell(i,'D')
      level = excel.cell(i,'E') || 0
      vit_power = excel.cell(i,'F')
 		if account && password
 			role = Role.create(:account=>account,:password=>password,:role_index=>role_index,:server=>server,:level=>level,:vit_power=>vit_power)
 			count = count + 1
 		end
     end
      self.update_attributes(:imported=>true,:imported_at=>Time.now,:import_count=>count)
   end

   # 导入账户
   def to_accounts
      filename = "#{Rails.root}/public/#{self.file.to_s}"
      return false unless File.exists?(filename)
      count = 0
      File.open(filename) do |file|    
        file.each_line do |line|
          line = line.gsub("\r\n","")
          tmp = line.split("----")
          if tmp && tmp.length >= 2
            account = Account.new(:no=>tmp[0],:password=>tmp[1]) 
            unless Account.exists?(:no=>tmp[0]) 
              count = count + 1 if account.save
            end
            
          end
        end    
        file.close();    
      end
      self.update_attributes(:imported=>true,:imported_at=>Time.now,:import_count=>count) 
   end
   
end
