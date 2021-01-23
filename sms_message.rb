require_relative './message'

class SmsMessage < Message
  MAX_SENDABEL_MESSAGE_LENGTH = 160
  MIN_SUFFIX_LENGTH = 14

  def split_message_into_mulitpart_chuncks
    @message.length < 160 ? [@message] : compose_chuncks_to_multipart_message_array
  end

  private

  def compose_chuncks_to_multipart_message_array
    split_message_to_array.map.with_index {|chunck, i| "#{chunck} - Part #{i+1} of #{calculate_total_pages}" }
  end

  def calculate_total_pages
    split_message_to_array.length
  end

  def split_message_to_array
    @message_array ||= @message.scan(/.{1,#{calculate_current_chunck_length}}/m)
  end

  def calculate_current_chunck_length
    MAX_SENDABEL_MESSAGE_LENGTH - estimate_page_suffix_length
  end

  # estimate the total pages page_suffix depends on assumption of min suffix length
  def estimate_page_suffix_length
    " - Part #{estimate_total_pages} of #{estimate_total_pages}".length
  end

  def estimate_total_pages
    @estimated_total_pages ||= @message.scan(/.{1,#{MAX_SENDABEL_MESSAGE_LENGTH - MIN_SUFFIX_LENGTH}}/m).length
  end
end
