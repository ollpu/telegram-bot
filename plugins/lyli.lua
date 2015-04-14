local captured_URL_table
function lyliit(targ)
  -- Properly escape the input
  targ = string.gsub(targ, '(["|\'|\\{|\\}])', '\\%1')
  local handle = io.popen("curl -H 'Content-Type: application/json' -X POST -d '{\"url\": \""..targ.."\"}' api.lyli.fi")
  local result = handle:read("*a")
  handle:close()
  return result
end

function piliit(from)
	from = string.gsub(from, "'", "\\'")
	local handle = io.popen("curl 'api.lyli.fi/"..from.."'")
  	local result = handle:read("*a")
  	handle:close()
  	return result
end

function lylic(targ, name)
  targ = string.gsub(targ, '(["|\'|\\{|\\}])', '\\%1')
  name = string.gsub(name, '(["|\'|\\{|\\}])', '\\%1')
  local handle = io.popen("curl -H 'Content-Type: application/json' -X POST -d '{\"url\": \""..targ.."\", \"name\": \""..name.."\"}' api.lyli.fi")
  local result = handle:read("*a")
  handle:close()
  return result
end

function lyli_clean(str)
  return string.gsub(str, '["|\\{|\\}]', '')
end


function run(msg, matches)
  local results = "lyli plugin is confused."
  if(string.match(msg.text, "^!lyli (.*)$")) then
  	results = lyliit(matches[1])
  elseif string.match(msg.text, "^!pili (.*)$") then
  	results = piliit(matches[1])
  elseif string.match(msg.text, "^!lyli$") then
    local to_id = msg.to.id
    local onfail = "I have no previous link stored in my database 😞. You can also use !lyli [URL] to shorten a URL."
    if captured_URL_table ~= nil then
      if captured_URL_table[tostring(to_id)] ~= nil then
        results = lyliit(captured_URL_table[tostring(to_id)])
      else results = onfail.." (Debug: cUt[to_id] is nil, to_id is "..to_id..")" end
    else results = onfail end
  elseif string.match(msg.text, "^!lylic (.*)$") then
    local to_id = msg.to.id
    local onfail = "I have no previous link stored in my database 😞. You can also use !lyli [URL] to shorten a URL."
    if captured_URL_table ~= nil then
      if captured_URL_table[tostring(to_id)] ~= nil then
        results = lylic(captured_URL_table[tostring(to_id)], matches[1])
      else results = onfail.." (Debug: cUt[to_id] is nil, to_id is "..to_id..")" end
    else results = onfail end
  elseif string.match(msg.text, "(https?://[%w-_%.%?%.:/%+=&]+)") then
    if not string.match(msg.text, "^❱") then
      results = catch_url(msg, matches)
    else return nil end
  end
  return lyli_clean(results)
  
end

function catch_url(msg, matches)
  local toreturn = nil
  local to_id = tostring(msg.to.id)
  
  if captured_URL_table == nil then
    captured_URL_table = {}
  end
  --Advertize the quick-shortening functionality only on the first time
  --we catch a URL.
  if captured_URL_table[tostring(to_id)] == nil then
    toreturn = "Use !lyli (or !lylic [name] for a custom name) to shorten that link!"
  end
  
  captured_URL_table[tostring(to_id)] = matches[1]
  
  return toreturn
end

return {
  description = "Creates a lyli link (using api.lyli.fi)",
  usage =  {
    "!lyli [url]: Shortens a long URL using lyli.fi.",
    "!pili [text]: Gets the target of link lyli.fi/text",
    "!lyli: Shortens the last URL sent to this chat",
    "!lylic [name]: Shortens the last URL sent to this chat with custon name"
  },
  patterns = {
    "^!lyli (.*)$",
    "^!pili (.*)$",
    "(https?://[%w-_%.%?%.:/%+=&]+)",
    "^!lyli$",
    "^!lylic (.*)$"
  },
  run = run
}
