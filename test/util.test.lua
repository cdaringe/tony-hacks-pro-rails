require "src.util"

lu = require('luaunit')

local plus1 = function (x) return x + 1 end

function test_map_with_no_data()
  lu.assertEquals(map(plus1, {}), {})
end

function test_map_with_data()
  local collection_a = { 1, 2, 3 }
  local collection_b = map(plus1, collection_a)
  lu.assertEquals(collection_b, { 2, 3, 4})
end

function test_is_not_nil()
  lu.assertEquals(is_not_nil(), false)
  lu.assertEquals(is_not_nil(nil), false)
  lu.assertEquals(is_not_nil(1), true)
  lu.assertEquals(is_not_nil({}), true)
end

function test_find_with_data()
  local collection_a = { 'a', 'b', 'c' }
  local res = find(function(x) return x == 'c' end, collection_a)
  lu.assertEquals(res, 'c')
  lu.assertEquals(find(function(x) return x == 'c' end, {}), nil)
end

function test_filter_with_data()
  local collection_a = { 1,2,3,4 }
  local res = filter(function(x) return x % 2 == 0 end, collection_a)
  lu.assertEquals(res, {2, 4})
  lu.assertEquals(filter(function(x) return x % 5 == 0 end, collection_a), {})
end

function test_some_with_data()
  local is_mod_5 = function(x) return x % 5 == 0 end
  local collection_a = { 1,2,3,4 }
  local res = some(function(x) return x % 2 == 0 end, collection_a)
  lu.assertEquals(res, true)
  lu.assertEquals(some(is_mod_5, collection_a), false)
end


os.exit(lu.LuaUnit.run())
