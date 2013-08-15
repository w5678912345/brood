json.array! @servers do |server|
  json.id server.id
  json.name server.name
  json.goods server.goods
  json.price server.price
end