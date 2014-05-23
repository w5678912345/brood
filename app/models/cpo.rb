class Cpo


	# USER_EMAIL = 'bolt@dabi.co'
	# USESR_PASSWORD = '12345678'
	#require 'net/http'

	COOKIE = ""


	def self.update_stored ids
		cookie = Cpo.sign_in
		uri = URI("#{AppSettings.cpo.url}/user_accounts/update_stored.json")
		req = Net::HTTP::Post.new(uri)
		req.set_form_data("_method"=>"put","ids[]"=>ids,"stored"=>"1")

		req.initialize_http_header({"cookie"=>cookie})
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		case res
		when Net::HTTPSuccess, Net::HTTPRedirection
		 	p "update ok"
		else
		  res.value
		end
	end

	def self.sign_in

		uri = URI("#{AppSettings.cpo.url}/users/sign_in.json")
		req = Net::HTTP::Post.new(uri)
		req.set_form_data('user[email]' => AppSettings.cpo.email, 'user[password]' => AppSettings.cpo.password,'user[remember_me]'=>1)

		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		cookie = res['Set-Cookie']
		case res
		when Net::HTTPSuccess, Net::HTTPRedirection
		 	p "ok"
		else
		  res.value
		end
		return cookie
	end


	def self.get_avail_account
		cookie = Cpo.sign_in
		uri = URI("#{AppSettings.cpo.url}/avail_accounts.json")
		req = Net::HTTP::Get.new(uri)
		req.initialize_http_header({"cookie"=>cookie})
		res = Net::HTTP.start(uri.hostname,uri.port) do |http|
			http.request(req)
		end
		JSON.parse(res.body) 
	end

	def self.get_un_stored_accounts
		cookie = Cpo.sign_in
		uri = URI("#{AppSettings.cpo.url}/unstored_user_accounts.json")
		req = Net::HTTP::Get.new(uri)
		req.initialize_http_header({"cookie"=>cookie})
		res = Net::HTTP.start(uri.hostname,uri.port) do |http|
			http.request(req)
		end
		JSON.parse(res.body) 
	end

	


	

end