json.array! @accounts do |a|
  json.no a.no
  json.password a.password
  json.phone_id a.phone_id
  json.phone_online a.phone.online if a.phone
  json.server a.server
  json.computer_name a.bind_computer.hostname if a.bind_computer
  json.status a.status
end