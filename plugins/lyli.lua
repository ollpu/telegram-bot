
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
  if(string.match(msg.text, "!lyli (.*)$")) then
  	results = lyliit(matches[1])
  else
  	results = piliit(matches[1])
  end
  return results
end

return {
  description = "Creates a lyli link (using api.lyli.fi)",
  usage =  {
    "!lyli [url]: Shortens a long URL using lyli.fi.",
    "!pili [text]: Gets the target of link lyli.fi/text"
  },
  patterns = {
    "^!lyli (.*)$",
    "^!pili (.*)$"
  },
  run = run
}

