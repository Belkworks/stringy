if not NEON then
  if not isfile('neon/init.lua') then
    makefolder('neon')
    local raw = 'https://raw.githubusercontent.com/%s/%s/master/init.lua'
    writefile('neon/init.lua', game:HttpGet(raw:format('belkworks', 'neon')))
  end
  pcall(loadfile('neon/init.lua'))
  assert(NEON, 'failed to load neon!')
end
local HttpService = game:GetService('HttpService')
local Chalk = NEON:github('belkworks', 'chalk')
local insert, concat
do
  local _obj_0 = table
  insert, concat = _obj_0.insert, _obj_0.concat
end
local keys
keys = function(t)
  local _accum_0 = { }
  local _len_0 = 1
  for k in pairs(t) do
    _accum_0[_len_0] = k
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local isArray
isArray = function(t)
  return #t == #keys(t)
end
local capFirst
capFirst = function(s)
  return s:sub(1, 1):upper() .. s:sub(2)
end
local stringify
stringify = function() end
local stringifyTable
stringifyTable = function(t, depth, explored)
  if depth == nil then
    depth = 0
  end
  if explored == nil then
    explored = { }
  end
  local me = explored[t]
  explored[t] = explored[t] or 0
  local unexplored = explored[t] == 0
  explored[t] = explored[t] + 1
  if explored[t] > 1 then
    return Chalk.light.blue("[Circular]")
  end
  local array = isArray(t)
  local keylist = keys(t)
  local keysc = #keylist
  local brackets
  if array then
    brackets = {
      '[',
      ']'
    }
  else
    brackets = {
      '{',
      '}'
    }
  end
  local r = {
    brackets[1],
    '\n'
  }
  depth = depth + 1
  for i, k in pairs(keylist) do
    local value = t[k]
    insert(r, ('    '):rep(depth))
    if array then
      insert(r, stringify(value, depth, explored))
      if i < keysc then
        insert(r, ', ')
      end
    else
      k = stringify(k, depth, explored)
      local v = stringify(value, depth, explored)
      do
        local count = explored[value]
        if count then
          if explored[t] + 1 == count then
            k = k .. Chalk.light.cyan(" <ref>")
          end
        end
      end
      insert(r, k .. ': ' .. v)
    end
    insert(r, '\n')
  end
  insert(r, ('    '):rep(depth - 1))
  insert(r, brackets[2])
  return concat(r, '')
end
stringify = function(any, ...)
  local _exp_0 = type(any)
  if 'string' == _exp_0 then
    return Chalk.green(HttpService:JSONEncode(any))
  elseif 'boolean' == _exp_0 or 'number' == _exp_0 then
    return Chalk.yellow(any)
  elseif 'table' == _exp_0 then
    return stringifyTable(any, ...)
  elseif 'function' == _exp_0 then
    return Chalk.light.blue("[" .. tostring(capFirst(tostring(any))) .. "]")
  elseif 'userdata' == _exp_0 then
    local t = typeof(any)
    local str
    if t ~= 'userdata' then
      if t == 'Instance' then
        local path = any:GetFullName()
        local whitePath = Chalk.white("(" .. tostring(path) .. ")")
        str = tostring(any.ClassName) .. " " .. tostring(any) .. " " .. tostring(whitePath)
      else
        str = tostring(t) .. " " .. tostring(any)
      end
    else
      str = any
    end
    return Chalk.light.cyan(str)
  elseif 'vector' == _exp_0 then
    return "Vector3(" .. tostring(Chalk.yellow(any)) .. ")"
  else
    return Chalk.light.red(any)
  end
end
return function(...)
  return Chalk.print(unpack((function(...)
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = {
      ...
    }
    for _index_0 = 1, #_list_0 do
      local v = _list_0[_index_0]
      _accum_0[_len_0] = stringify(v)
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)(...)))
end
