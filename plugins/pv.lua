﻿local function do_keyboard_endchat()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = '🔚End Chat', callback_data = '/end'}
	    }
    }
    return keyboard
end
local action = function(msg,blocks, ln)
local msg_id = msg.message_id
local user_id = msg.chat.id
local hash = 'pm:user'
local chat_info = db:hget(hash,user_id)
if blocks[1] == 'chat' then
if chat_info == 'block' then 
 api.sendMessage(msg.chat.id, '_You are Blocked_ *Miss Message* :D', true) 
else
 db:hset(hash, user_id, 'true')
 api.sendMessage(msg.chat.id, '*Chat Started!*\n`چت اغاز شد اگر از قسمت دریافت گروه های رایگان مراجعه میکنید \nخواهشا لینک گروه خود را ارسال کنید`\n`اگر امر دیگری هم هست در خدمتم.`\n_Now You all message Send to_ @MrBlackLife', true) 
 end
 end
if blocks[1] == 'end' then
if chat_info == 'block' or chat_info == 'false' then 
return nil 
else
 db:hset(hash, user_id, 'false')
api.sendMessage(msg.chat.id, '*Chat Was Ended*\n`Welcome Back To Home`', true) 
end
end
if msg.chat.type == 'private' and chat_info == 'true' then
if blocks[1] == 'end' or blocks[1] == 'chat' then return nil end
api.forwardMessage('-133931992', msg.chat.id, msg_id) 
api.sendKeyboard(msg.chat.id, '`Your Message Succefulli Recieved!`\nWait For Answer.\n`پیام شما رسید`\n`منتظر جواب باشید`'  ,do_keyboard_endchat(), true)
end
if blocks[1] == 'block' then
if msg.reply and msg.reply.forward_from and msg.chat.type == 'group' and msg.chat.id == -133931992 and not blocks[2] then
msg = msg.reply
local user_id = msg.forward_from.id
 db:hset(hash, user_id, 'block')
api.sendMessage(msg.chat.id, '_User '..user_id..' Blocked_!', true) 
api.sendMessage(user_id, '`- Sorry`\n_You Blocked To This Bot_\n*Chat Ended!*', true) 
else
 if msg.chat.type == 'group' and msg.chat.id == -133931992 then
 if msg.reply then return nil end
local user_id = blocks[2]
 db:hset(hash, user_id, 'block')
api.sendMessage(msg.chat.id, '_User '..user_id..' Blocked_', true) 
api.sendMessage(user_id, '`- Sorry`\n_You are Blocked_', true) 
end 
end
end
if blocks[1] == 'unblock' then
if msg.reply and msg.reply.forward_from and msg.chat.type == 'group' and msg.chat.id == -133931992 and not blocks[2] then
msg = msg.reply
local user_id = msg.forward_from.id
 db:hset(hash, user_id, 'false')
api.sendMessage(msg.chat.id, '_User '..user_id..' UnBlocked_', true) 
api.sendMessage(user_id, '_You UnBlocked To This Bot_', true) 
else
 if msg.chat.type == 'group' and msg.chat.id == -133931992 then
  if msg.reply then return nil end
local user_id = blocks[2]
 db:hset(hash, user_id, 'false')
api.sendMessage(msg.chat.id, '_User '..user_id..' UnBlocked_', true) 
api.sendMessage(user_id, '_You UnBlocked To This Bot_', true) 
end 
end
end
    if msg.reply and msg.reply.forward_from and msg.chat.type == 'group' and msg.chat.id == -133931992 then
   msg = msg.reply_to_message
    local receiver = msg.forward_from.id
    local input = blocks[1]
      api.sendMessage(receiver, 'پاسخ/Response : \n'..input, false)
end
end
return {
  action = action,
triggers = {
    '^/(unblock) (%d+)$',
    '^/(block) (%d+)$',
    '^/(unblock)$',
    '^/(block)$',
    '^/(chat)$',
    '^/(end)$',
	'^###cb:/(chat)',
	'^###cb:/(end)',
    '^(.*)$',
    }
}
