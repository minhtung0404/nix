local function unwrap_key(key_code)
  if key_code == "/" then
    return {}, "/"
  end
  if key_code == "<esc>" then
    return {}, "escape"
  end

  if key_code == "<cr>" then
    return {}, "return"
  end

  if key_code == "$" then
    return { "shift" }, "4"
  end

  if key_code:match("%u") then
    return { "shift" }, key_code
  end

  if key_code:match("%a") or key_code:match("%d") then
    return {}, key_code
  end
end

return unwrap_key
