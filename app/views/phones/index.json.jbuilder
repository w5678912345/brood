json.array! @phones.resultset do |p|
  json.phone_id p.no
  json.iccid p.iccid
  json.online p.online
end