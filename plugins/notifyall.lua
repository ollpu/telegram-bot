
function run(msg, matches)
  return chat_info(msg.to.id)
end

return {
    description = "Notifies all users in this chat.",
    usage = "!notifyall: notify all people in this chat",
    patterns = {"^!notfyall$"},
    run = run
}
