# encoding: utf-8
class NoteDataNodesController < ApplicationController
	def index
		@events = ['role_start','bslock','discardfordays','discardbysailia','discardforyears']
		@start_date = Date.today - 7.day
		@end_date = Date.today + 1.day
		@start_date = Date.parse(params[:start_date]) unless params[:start_date].blank?
		@end_date = Date.parse(params[:end_date])  unless params[:end_date].blank?

		@data_nodes = DataNode.where(:source=>"notes").date_scope(@start_date,@end_date).order("marked_at desc")
	end
end