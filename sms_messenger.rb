
# SMS can only be a maximum of 160 characters.
# If the user wants to send a message bigger than that, we need to break it up.
# We want a multi-part message to have this suffix added to each message:
# " - Part X of Y"

class SmsMessenger
  SMS_LENGTH = 160
  MIN_SUFFIX_LENGTH = 14 # minimum length of the page suffix ' - Part X of Y', will be higher if message length grow. 

  # You need to fix this method, currently it will crash with > 160 char messages.
  def send_sms_message(text, to, from)
    if text.length < 160 # if message in shorter than 160 characters send it immediately
      deliver_message_via_carrier(text, to, from)
    else
      chunck_array = split_message_into_chuncks(text) # split text into chuncks with a character length < 160
      total_pages = calculate_total_pages(text) # calculate total pages

      chunck_array.each_with_index do |chunck, i|
        message_chunck_to_send = compose_message(chunck, i+1, total_pages) # compose messsage to send

        deliver_message_via_carrier(message_chunck_to_send, to, from)
      end
    end
  end

  # This method actually sends the message via a SMS carrier
  # This method works, __you don't change it__,
  def deliver_message_via_carrier(text, to, from)
    SMS_CARRIER.deliver_message(text, to, from)
  end

  # calculate total pages dependent on calculated page_suffix_length
  def calculate_total_pages(text)
    split_message_into_chuncks(text).length
  end

  # compose message to send 
  def compose_message(chunck, page, total_pages)
    chunck + compose_pages_suffix(page, total_pages)
  end

   # split message into sendable chuncks
  def split_message_into_chuncks(text)
    current_chunck_length = SMS_LENGTH - calculate_page_suffix_length(text)

    text.scan(/.{1,#{current_chunck_length}}/)
  end

  # compose the page suffix
  def compose_pages_suffix(page, total_pages)
    " - Part #{page} of #{total_pages}"
  end

  # calculate current max page suffix length
  def calculate_page_suffix_length(text)
    text_array = text.scan(/.{1,#{initial_chunck_length}}/)
    estimated_total_pages = text_array.length

    compose_pages_suffix(estimated_total_pages-1, estimated_total_pages).length
  end

  # calculate inital chunck length
  def initial_chunck_length
    SMS_LENGTH - MIN_SUFFIX_LENGTH
  end
  
end
