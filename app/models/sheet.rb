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
 		account = excel.cell(i,'A')
 		password = excel.cell(i,'B')
 		name = excel.cell(i,'C')
 		server = excel.cell(i,'D')
 		if account && password && name && server
 			role = Role.create(:account=>account,:password=>password,:name=>name,:server=>server)
 			count = count + 1
 		end
     end
      self.update_attributes(:imported=>true,:imported_at=>Time.now,:import_count=>count)
   end
   
end
