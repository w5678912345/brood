# encoding: utf-8
class Analysis::NoteController < Analysis::AppController


	def show
		@start_date = Time.now - 7.day
		@end_date = Time.now + 1.day
		
	end

end