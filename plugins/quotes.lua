local quotes_file = './data/quotes.lua'
local quotes_table

function read_quotes_file()
    local f = io.open(quotes_file, "r+")

    if f == nil then
        print ('Created a new quotes file on '..quotes_file)
        serialize_to_file({}, quotes_file)
    else
        print ('Quotes loaded: '..quotes_file)
        f:close()
    end
    return loadfile (quotes_file)()
end

function save_quote(msg)
    local to_id = tostring(msg.to.id)

    if msg.text:sub(11):isempty() then
        return "Usage: !addquote quote"
    end

    if quotes_table == nil then
        quotes_table = {}
    end

    if quotes_table[to_id] == nil then
        print ('New quote key to_id: '..to_id)
        quotes_table[to_id] = {}
    end

    local quotes = quotes_table[to_id]
    quotes[#quotes+1] = msg.text:sub(11)

    serialize_to_file(quotes_table, quotes_file)

    return "Added new private quote!"
end

function save_public_quote(msg)
  local to_id = tostring("public")

  if msg.text:sub(17):isempty() then
      return "Usage: !addpublicquote quote"
  end

  if quotes_table == nil then
      quotes_table = {}
  end

  if quotes_table[to_id] == nil then
      print ('New quote key to_id: '..to_id)
      quotes_table[to_id] = {}
  end

  local quotes = quotes_table[to_id]
  quotes[#quotes+1] = msg.text:sub(17)

  serialize_to_file(quotes_table, quotes_file)

  return "Added new public quote!"
end

function get_quote(msg)
  local to_id = tostring(msg.to.id)
  local quotes_phrases

  quotes_table = read_quotes_file()
  quotes_phrases = TableConcat(quotes_table[to_id], quotes_table[tostring("public")])
  for i, phrase in ipairs(quotes_phrases) do print(phrase) end

  return quotes_phrases[math.random(1,#quotes_phrases)]
end

function TableConcat(t1,t2)
  local ii=0
  if t1 == nil then
    t1 = {}
  end
  
  for i=#t1+1, #t2+#t1 do
    ii=ii+1
    t1[i]=t2[ii]
  end
  return t1
end

function run(msg, matches)
    if string.match(msg.text, "!quote$") then
      return get_quote(msg)
    elseif string.match(msg.text, "!addquote (.+)$") then
      quotes_table = read_quotes_file()
      return save_quote(msg)
    elseif string.match(msg.text, "!addpublicquote (.+)$") then
      quotes_table = read_quotes_file()
      return save_public_quote(msg)
    end
end

return {
    description = "Save quote",
    description = "Quote plugin, you can create and retrieve random quotes",
    usage = {
        "!addquote [msg] - Adds a private quote, only retrievable in this chat",
        "!quote - Displays a quote which can be private or public",
        "!addpublicquote [msg]: Adds a public quote, retrievable in all chats"
    },
    patterns = {
        "^!addquote (.+)$",
        "^!quote$",
        "^!addpublicquote (.+)$"
    },
    run = run
}
