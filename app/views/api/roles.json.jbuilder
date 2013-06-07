json.array! @roles do |role|
  json.set! :role do
	  json.(role, :id,:account, :password,:server,:name,:online)
  end
end