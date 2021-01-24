require './sms_message'

# SMS can only be a maximum of 160 characters.
# If the user wants to send a message bigger than that, we need to break it up.
# We want a multi-part message to have this suffix added to each message:
# " - Part X of Y"
class SmsMessenger
  # You need to fix this method, currently it will crash with > 160 char messages.
  def send_sms_message(text, to, from)
    sms_message = SmsMessage.new(text)

    # It`s more sophisticated to split the message and keep words undivided.
    # More suitable for this purpose is the split_message_into_readable_multipart_chunks function.

    sms_message.split_message_into_mulitpart_chunks.each { |part| deliver_message_via_carrier(part, to, from) }
  end

  # This method actually sends the message via a SMS carrier
  # This method works, __you don't change it__,
  def deliver_message_via_carrier(text, to, from)
    SMS_CARRIER.deliver_message(text, to, from)
  end
end
