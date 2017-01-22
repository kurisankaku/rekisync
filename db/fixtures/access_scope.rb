AccessScope.master_codes.each_with_index do |code, index|
  AccessScope.seed do |o|
    o.id = index + 1
    o.code = code
  end
end
