require_relative './message'

class SmsMessage < Message
  MAX_SENDABEL_MESSAGE_LENGTH = 160 # max size of a sendable sms message
  MIN_SUFFIX_LENGTH = 14 # " - Part X of Y"

  # split message into chunks with prefix 
  def split_message_into_mulitpart_chunks
    @message.length < 160 ? [@message] : compose_chunks_to_multipart_message_array
  end

  # split message and avoid spliting words to improve readability of the multipart messages.  
  def split_message_into_readable_multipart_chunks
    @message.length < 160 ? [@message] : compose_words_to_multipart_message_array
  end

  private

  def compose_chunks_to_multipart_message_array
    split_message_to_array.map.with_index { |chunk, i| "#{chunk} - Part #{i+1} of #{calculate_total_pages}" }
  end

  def compose_words_to_multipart_message_array
    result_length = compose_words_to_chunk_array.length
    compose_words_to_chunk_array.map.with_index  { |chunk, i| "#{chunk}- Part #{i+1} of #{result_length}" }
  end

  # compose words to chunck array where each chunck is smaller
  # as the calculate_current_chunk_length without the page suffix
  def compose_words_to_chunk_array
    chunk_array = []
    chunk = ""
    split_messsage_to_words_array.each do |word|
      # check if the future chunck is smaller 
      if (chunk.length + word.length) < calculate_current_chunk_length
        chunk << word + " "
      else
        chunk_array << chunk.dup
        chunk = word + " "
      end
    end
    chunk_array << chunk
  end

  def split_messsage_to_words_array
    @message_word_array ||= @message.split(' ')
  end

  def calculate_total_pages
    split_message_to_array.length
  end

  def split_message_to_array
    @message_array ||= @message.scan(/.{1,#{calculate_current_chunk_length}}/m)
  end

  def calculate_current_chunk_length
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
