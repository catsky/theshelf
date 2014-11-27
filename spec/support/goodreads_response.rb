require 'nokogiri'

class GoodreadsResponse
  def mock_response
    {
      isbn: goodreads_response.css('book').first.css('isbn13').first.content,
      title: goodreads_response.css('book').first.css('title').first.content
    }
  end

  private

  def goodreads_response
    @_response ||= Nokogiri::XML(File.new('./spec/fixtures/goodreads_response.xml'))
  end
end
