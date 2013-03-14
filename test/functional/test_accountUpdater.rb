require 'lib/LitleOnline'
require 'test/unit'
require 'test/shared/data'

module LitleOnline
  class TestAccountUpdater < Test::Unit::TestCase
    def test_request_valid_format
      hash = batch_request_approved.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_batch_request(hash)
      assert_equal 'Valid Format', response.message
    end

    def test_response_success
      hash = batch_request_approved.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_batch_request(hash)
      assert_equal '0', response.response
    end

    def test_acknowledgement_response_approved
      hash = batch_request_approved.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_batch_request(hash)
      assert_equal '000', response.batchResponse.accountUpdateResponse.response
      assert_equal 'Approved', response.batchResponse.accountUpdateResponse.message
    end

    def test_acknowledgement_response_invalid_expiration_date
      hash = batch_request_invalid_expiration_date.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_batch_request(hash)
      assert_equal '320', response.batchResponse.accountUpdateResponse.response
      assert_equal 'Invalid Expiration Date', response.batchResponse.accountUpdateResponse.message
    end

    def test_acknowledgement_response_invalid_account_number
      hash = batch_request_invalid_account_number.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_batch_request(hash)
      assert_equal '301', response.batchResponse.accountUpdateResponse.response
      assert_equal 'Invalid Account Number', response.batchResponse.accountUpdateResponse.message
    end

    private

    def batch_request_approved
      {
        'batchRequest' => {
          'accountUpdate' => [
            {
              'orderId' => '1',
              'card' => {
                'type'=>'VI',
                'number' =>'4457010000000009',
                'expDate' =>'0912'
              }
            }
          ]
        }
      }
    end

    def batch_request_invalid_expiration_date
      {
        'batchRequest' => {
          'accountUpdate' => [
            {
              'orderId' => '4',
              'card' => {
                'type'=>'VI',
                'number' =>'4457000400000006',
                'expDate' =>'0000'
              }
            }
          ]
        }
      }
    end

    def batch_request_invalid_account_number
      {
        'batchRequest' => {
          'accountUpdate' => [
            {
              'orderId' => '10',
              'card' => {
                'type'=>'MC',
                'number' =>'5112000400400018',
                'expDate' =>'0210'
              }
            }
          ]
        }
      }
    end
  end
end
