json.array!(@maps) do |json,map|
  json.(map,:id,:key,:name,:enter_count,:ishell)
end