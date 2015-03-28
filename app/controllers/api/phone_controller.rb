# encoding: utf-8
class Api::PhoneController < Api::BaseController


	#根据事件 取得可用的手机号
	def get
    invalid_NO = Link.where(:event => params[:event]).where("enabled=false or (status='waiting' and updated_at > ?)",3.hours.ago).map(&:phone_no)
		phones = Phone.where(:enabled=>true)
    phones = phones.where("no not in (?)",invalid_NO) if invalid_NO.length > 0
		phone = phones.first
		return render :json => {:code => CODES[:not_find_phone]} unless phone
    link = Link.get(phone.no,params[:event])
    link.update_attributes(:status=>"waiting")
		render :json => {:code => 1, :no => phone.no}
	end

	#启用 或 禁用手机号
	def set_enable
    @phone = Phone.find_by_no(params[:no])
    return render :json => {:code => CODES[:not_find_phone]} unless @phone
    @phone.update_attributes(:enabled=>params[:enable].to_i)
    return render :json => {:code => 1}
  end

  #启用 或 禁用 手机号相关的
  def set_channel_enable
    @phone = Phone.find_by_no(params[:no])
    return render :json => {:code => CODES[:not_find_phone]} unless @phone
    return render :json => {:code => 0,:msg=>"no event"} if params[:event].blank?
    @link = Link.where(:phone_no=>@phone.no).where(:event=>params[:event]).first
    @link = Link.create(:phone_no => @phone.no,:event=>params[:event]) unless @link
    @link.update_attributes(:enabled=>params[:enable].to_i)
    return render :json => {:code => 1}
  end
end