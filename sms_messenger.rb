
# SMS can only be a maximum of 160 characters.
# If the user wants to send a message bigger than that, we need to break it up.
# We want a multi-part message to have this suffix added to each message:
# " - Part X of Y"

require './sms_message.rb'

class SmsMessenger
  SMS_LENGTH = 160
  MIN_SUFFIX_LENGTH = 14 # minimum length of the page suffix ' - Part X of Y', will be higher if message length grow. 

  # You need to fix this method, currently it will crash with > 160 char messages.
  def send_sms_message(text, to, from)
    sms_message = SmsMessage.new(text)
    
    sms_message.split_message_into_mulitpart_chuncks.each { |part| deliver_message_via_carrier(part, to, from) }
  end

  # This method actually sends the message via a SMS carrier
  # This method works, __you don't change it__,
  def deliver_message_via_carrier(text, to, from)
    SMS_CARRIER.deliver_message(text, to, from)
  end
  
end
