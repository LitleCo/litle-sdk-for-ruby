require 'lib/LitleOnline'
require 'test/unit'
require 'test/shared/data'

module LitleOnline
  class TestRFRRequest < Test::Unit::TestCase
    def test_response_account_update_file_not_ready
      hash = request_for_response.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_request_for_response(hash)
      assert_equal '1', response.RFRResponse.response
      assert_equal 'The account update file is not ready yet. Please try again later.', response.RFRResponse.message
    end

    private

    def request_for_response
      {
        'accountUpdateFileRequestData' => {
          'postDay' => '2013-03-12'
        }
      }
    end
  end
end
