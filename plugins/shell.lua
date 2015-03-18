
function execute(cmd)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return result
end




function run(msg, matches)
  return execute(matches[1])
end



return {
  description = "Executes a shell command. Requires priviliged user.",
  usage =  {
    "!sh or !shell [command]: Executes a bash command on local machine. Requires priviliged access."
  },
  patterns = {
    "^!sh (.*)$",
    "^!shell (.*)$"
  },
  run = run,
  privileged = true
}
