local function is_not_nil(v)
  return v ~= nil
end

local function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

local function find(func, array)
  for i,v in ipairs(array) do
    if func(v) then return v end
  end
end

local function some(func, array)
  for i,v in ipairs(array) do
    if func(v) then return true end
  end
  return false
end

local function filter(func, array)
  local new_array = {}
  local i = 1
  for _,v in ipairs(array) do
    if func(v) then
      new_array[i] = v
      i = i + 1
    end
  end
  return new_array
end

local function format_any_value(obj, buffer)
  local _type = type(obj)
  if _type == "table" then
      buffer[#buffer + 1] = '{"'
      for key, value in next, obj, nil do
          buffer[#buffer + 1] = tostring(key) .. '":'
          format_any_value(value, buffer)
          buffer[#buffer + 1] = ',"'
      end
      buffer[#buffer] = '}' -- note the overwrite
  elseif _type == "string" then
      buffer[#buffer + 1] = '"' .. obj .. '"'
  elseif _type == "boolean" or _type == "number" then
      buffer[#buffer + 1] = tostring(obj)
  else
      buffer[#buffer + 1] = '"???' .. _type .. '???"'
  end
end

local function to_json(obj)
  if obj == nil then return "null" else
      local buffer = {}
      format_any_value(obj, buffer)
      return table.concat(buffer)
  end
end

return {
  filter = filter,
  find = find,
  is_not_nil = is_not_nil,
  map = map,
  some = some,
  to_json = to_json
}


