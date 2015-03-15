
function run(msg, matches)
  return [[Telegram Bot (modified by @ollpu)
Currently running on a Raspberry Pi.]]
end

return {
    description = "Shows info about the bot", 
    usage = "!info: Shows info about the bot",
    patterns = {
      "^!info$"
    }, 
    run = run 
}

