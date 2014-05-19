class Cpo

	require 'net/http'

	def self.avail_account
		uri = URI('http://127.0.0.1:4001/hello.json')
		Net::HTTP.get(uri) # => String
	end


	def self.sign_in
		uri = URI('http://127.0.0.1:4001/users/sign_in.json')
		req = Net::HTTP::Post.new(uri)
		req.set_form_data('user[email]' => 'tianyi@dabi.co', 'user[password]' => '12345678','user[remember_me]'=>1)

		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end

		 p res.to_hash['set-cookie']

		case res
		when Net::HTTPSuccess, Net::HTTPRedirection
		  # OK
		  p "ok"
		else
		  res.value
		end

		
		
	end


end