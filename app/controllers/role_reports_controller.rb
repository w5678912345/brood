class RoleReportsController < ApplicationController
  def index
  end
  def show
    @cols = {"roles.profession" => "职业","floor(roles.level/10)*10"=>"等级","history_role_sessions.task" => "任务(副本)"} 
    @col = params[:col] || "roles.profession"
    @status = ["discardfordays","discardforyear","discardforweek","disconnect"]
    params[:status] = 'disconnect' if not params[:status].present?
    @records = HistoryRoleSession.joins(:role).select("count(*) as roles_count, #{@col} as col").group(@col)
    .reorder("roles_count desc").where("history_role_sessions.created_at > ?",Time.now.beginning_of_day)
    @records = @records.where(:server => params[:server]) if params[:server].present?
    @records = @records.where("result" => params[:status]) if params[:status].present?
  end
end