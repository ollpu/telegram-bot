
function run(msg, matches)
  return [[Telegram Bot (modified by @ollpu)
Currently running on a Raspberry Pi.
GitHub repo: github.com/ollpu/telegram-bot]]
end

return {
    description = "Shows info about the bot", 
    usage = "!info: Shows info about the bot",
    patterns = {
      "^!info$"
    }, 
    run = run 
}

