require "test/unit"
require_relative './sms_messenger'

class SmsMessengerTest < Test::Unit::TestCase

  TEST_MESSAGE_1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  TEST_MESSAGE_2 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." * 1000

  TEST_MESSAGE_3 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the "
  EXPECTED_CHUNCK = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the  - Part 1 of 2"

  def test_page_suffix
    assert_equal " - Part 1 of 100", SmsMessenger.new.compose_pages_suffix(1, 100), "SmsMessenger.page_suffix should return a string called ' - Part 1 of 100'"
  end

  def test_calculate_page_suffix_length
    assert_equal 20, SmsMessenger.new.calculate_page_suffix_length(TEST_MESSAGE_2), "SmsMessenger.new.page_suffix_length should return a length of '12'"
  end

  def test_calculate_total_pages
    assert_equal 4100, SmsMessenger.new.calculate_total_pages(TEST_MESSAGE_2), "it should return the expected page count"
  end

  def test_split_message_into_chuncks
    expected_array_length = 4100

    assert_equal 4100, SmsMessenger.new.split_message_into_chuncks(TEST_MESSAGE_2).length, "it should return expected array length"
  end

  def test_compose_message
    assert_equal EXPECTED_CHUNCK, SmsMessenger.new.compose_message(TEST_MESSAGE_3, 1, 2), "it should return a valid string chunck"
  end

  def test_chuncks_length
    test_chunck_array = SmsMessenger.new.split_message_into_chuncks(TEST_MESSAGE_2)
    test_total_pages = SmsMessenger.new.calculate_total_pages(TEST_MESSAGE_2)

    test_chunck_array.each_with_index do |chunck, i|
      assert_equal true, SmsMessenger.new.compose_message(chunck, i+1, test_total_pages).length < 161, "it should be smaller then 161 characters"
    end

  end
end