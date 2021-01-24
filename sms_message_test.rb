require "test/unit"
require_relative './sms_message.rb'

class SmsMessageTest < Test::Unit::TestCase
  
  TEST_MESSAGE_1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  TEST_MESSAGE_2 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." * 1000
  TEST_MESSAGE_3 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
  
  def setup
    @subject_1 = SmsMessage.new(TEST_MESSAGE_1)
    @subject_2 = SmsMessage.new(TEST_MESSAGE_2)
    @subject_3 = SmsMessage.new(TEST_MESSAGE_3)
  end

  def test_split_message_into_mulitpart_chunks
    assert_equal 4, @subject_1.split_message_into_mulitpart_chunks.length, "it should return the expected chunk count"
    assert_equal 4100, @subject_2.split_message_into_mulitpart_chunks.length, "it should return the expected chunk count"
    assert_equal 1, @subject_3.split_message_into_mulitpart_chunks.length, "it should return the expected chunk count"
  end

  def test_split_message_into_multipart_chunks_readable
    assert_equal 4, @subject_1.split_message_into_multipart_chunks_readable.length, "it should return the expected word chunk count"
    assert_equal 4223, @subject_2.split_message_into_multipart_chunks_readable.length, "it should return the expected word chunk count"
    assert_equal 1, @subject_3.split_message_into_multipart_chunks_readable.length, "it should return the expected word chunk count"
  end

end
