# encoding: utf-8
class Note < ActiveRecord::Base

	belongs_to :computer
    belongs_to  :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no'
	belongs_to :role
    belongs_to :session, :class_name => 'Note', :foreign_key => 'session_id'
    has_many :notes,   :class_name => 'Note', :foreign_key => 'session_id'
    has_many :subs,    :class_name => 'Note', :foreign_key => 'sup_id'
    #has_many
	#
    attr_accessible :user_id, :role_id, :computer_id, :api_name, :api_code, :ip, :msg, :online_at, :online_note_id, :online_hours
    attr_accessible :level, :version, :account, :server, :hostname, :session_id
    #
    attr_accessible :sup_id, :effective, :ending, :success, :hours, :gold
    attr_accessible :started_at, :stopped_at, :success_at, :target, :result
    #
    default_scope :order => 'id DESC'

    scope :time_scope,lambda{|start_time,end_time|where(created_at: start_time..end_time)}

    scope :online_at_scope,lambda{|start_time,end_time|where(online_at: start_time..end_time)}

    scope :date_scope,lambda{|start_date,end_date|where(created_at: start_date.at_beginning_of_day..end_date.end_of_day)}

    scope :day_scope,lambda{|time|time_scope(time,time+1.day)}
    
    scope :event_scope, lambda{|event|where(:api_name => event)}
    #
    scope :local_scope, where(:ip => 'localhost')
    scope :computer_session_scope, includes(:computer).where(:api_name => "computer_start")
    scope :account_session_scope, includes(:computer).where(:api_name => "account_start")
    scope :role_session_scope, where(:api_name => "role_start")
    scope :session_scope, where("api_name in ('computer_start','account_start','role_start')")
    scope :non_session_scope, where("api_name != 'computer_start' and api_name != 'account_start' and api_name != 'role_start'")
    scope :success_scope, where(:success => true)
    scope :day_grpup_scope,lambda{|day|select("count(id) as ncount,api_name").where("date(created_at)=?",day).group("api_name").reorder("api_name")}


    #判断当前note 是否为一个session
    def is_session?
        return ['computer_start','account_start','role_start'].include? self.api_name
    end


    def is_computer_session?
        return self.api_name == 'computer_start'
    end

    def is_account_session?
        return self.api_name == 'account_start'
    end

    def is_role_session?
        return self.api_name == 'role_start'
    end

    def update_hours
        return unless self.is_session?
        now = Time.now
        hours = (now - self.created_at)/3600
        self.update_attributes(:hours=>hours)
    end

    # 当前会话完成的角色ID
    def success_role_ids
        return [] unless self.api_name == 'account_start'
        self.subs.role_session_scope.success_scope.select(:role_id).reorder("role_id desc").uniq().map(&:role_id)
    end

    #
    def self.list_search opts
        notes = Note.where("id>0")
        notes = notes.where(:role_id => opts[:role_id]) unless opts[:role_id].blank?
        notes = notes.where("session_id =? or id = ? ",opts[:session_id].to_i,opts[:session_id].to_i) unless opts[:session_id].blank?
        notes = notes.where(:account => opts[:account]) unless opts[:account].blank?
        notes = notes.where(:server => opts[:server]) unless opts[:server].blank?
        notes = notes.where(:computer_id => opts[:cid]) unless opts[:cid].blank?
        notes = notes.where(:api_name => opts[:api_name]) unless opts[:api_name].blank?
        #notes = notes.where(:api_name => opts[:event]) unless opts[:event].blank?
        notes = notes.where("ip like ?","%#{opts[:ip]}%") unless opts[:ip].blank?
        notes = notes.where("msg like ?","%#{opts[:msg]}%") unless opts[:msg].blank?
        notes = notes.where("date(created_at) = ?",opts[:date]) unless opts[:date].blank?
        notes = notes.where("created_at >= '#{opts[:start_date]} 06:00:00'") unless opts[:start_date].blank?
        notes = notes.where("created_at <= '#{opts[:end_date]} 06:00:00'") unless opts[:end_date].blank?
        notes = notes.where(:api_code => opts[:code]) unless opts[:code].blank?
        notes = notes.where(:version => opts[:version]) unless opts[:version].blank?
        #
        notes = notes.where(:ending => opts[:end].to_i) unless opts[:end].blank?
        notes = notes.where(:success => opts[:success].to_i) unless opts[:success].blank?
        notes = notes.where(:result => opts[:result]) unless opts[:result].blank?
        return notes
    end

end
