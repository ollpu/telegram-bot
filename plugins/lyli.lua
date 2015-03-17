local captured_URL_table
function lyliit(targ)
  
  local handle = io.popen("curl -H 'Content-Type: application/json' -X POST -d '{\"url\": \""..targ.."\"}' api.lyli.fi")
  local result = handle:read("*a")
  handle:close()
  return result
end

function piliit(from)
	local handle = io.popen("curl api.lyli.fi/"..from)
  	local result = handle:read("*a")
  	handle:close()
  	return result
end


function run(msg, matches)
  local results = "lyli plugin is confused."
  if(string.match(msg.text, "^!lyli (.*)$")) then
  	results = lyliit(matches[1])
  elseif string.match(msg.text, "^!pili (.*)$") then
  	results = piliit(matches[1])
  elseif string.match(msg.text, "^!lyli$") then
    local to_id = msg.to.id
    if captured_URL_table ~= nil then
      if captured_URL_table[to_id] ~= nil then
        results = lyliit(captured_URL_table[to_id])
      end
    end
  elseif string.match(msg.text, "\b(https?://[-A-Z0-9+&@#/%?=~_|!:,.;]*[A-Z0-9+&@#/%=~_|])") and not string.match(msg.text, "^❱") then
    results = catch_url(msg)
  end
  return results
end

function catch_url(msg)
  local to_id = tostring(msg.to.id)

  if captured_URL_table == nil then
    captured_URL_table = {}
  end
  
  captured_URL_table[to_id] = matches[1]

  return "Use !lyli to shorten that link!"
end

return {
  description = "Creates a lyli link (using api.lyli.fi)",
  usage =  {
    "!lyli [url]: Shortens a long URL using lyli.fi.",
    "!pili [text]: Gets the target of link lyli.fi/text",
    "!lyli: Shortens the last URL sent to this chat"
  },
  patterns = {
    "^!lyli (.*)$",
    "^!pili (.*)$",
    "\b(https?://[-A-Z0-9+&@#/%?=~_|!:,.;]*[A-Z0-9+&@#/%=~_|])",
    "^!lyli$"
  },
  run = run
}
