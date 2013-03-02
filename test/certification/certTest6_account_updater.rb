require 'lib/LitleOnline'

#require 'Litle_activemerchant'
require 'test/unit'
require 'test/shared/data'

module LitleOnline
  class Litle_certTest6 < Test::Unit::TestCase
    def test_batch_request_account_updater_transactions
      customer_hash = {
        'batchRequest' => {
          'accountUpdate' => [
            {
              'orderId' => '1',
              'card' => {
                'type'=>'VI',
                'number' =>'4457010000000009',
                'expDate' =>'0912'
              },
              'response' => {
                'code' => '000',
                'message' => 'Approved'
              }
            },
            {
              'orderId' => '2',
              'card' => {
                'type'=>'VI',
                'number' =>'4457003100000003',
                'expDate' =>'0509'
              },
              'response' => {
                'code' => '000',
                'message' => 'Approved'
              }
            },
            {
              'orderId' => '3',
              'card' => {
                'type'=>'VI',
                'number' =>'4457000300000007',
                'expDate' =>'0109'
              },
              'response' => {
                'code' => '000',
                'message' => 'Approved'
              }
            },
            {
              'orderId' => '4',
              'card' => {
                'type'=>'VI',
                'number' =>'4457000400000006',
                'expDate' =>'0000'
              },
              'response' => {
                'code' => '320',
                'message' => 'Invalid Expiration Date'
              }
            },
            {
              'orderId' => '5',
              'card' => {
                'type'=>'VI',
                'number' =>'4457000200400008',
                'expDate' =>'0210'
              },
              'response' => {
                'code' => '301',
                'message' => 'Invalid Account Number'
              }
            },
            {
              'orderId' => '6',
              'card' => {
                'type'=>'MC',
                'number' =>'5112010000000003',
                'expDate' =>'0210'
              },
              'response' => {
                'code' => '000',
                'message' => 'Approved'
              }
            },
            {
              'orderId' => '7',
              'card' => {
                'type'=>'MC',
                'number' =>'5112002200000008',
                'expDate' =>'0912'
              },
              'response' => {
                'code' => '000',
                'message' => 'Approved'
              }
            },
            {
              'orderId' => '8',
              'card' => {
                'type'=>'MC',
                'number' =>'5112000200000002',
                'expDate' =>'0509'
              },
              'response' => {
                'code' => '000',
                'message' => 'Approved'
              }
            },
            {
              'orderId' => '9',
              'card' => {
                'type'=>'MC',
                'number' =>'5112002100000009',
                'expDate' =>'0000'
              },
              'response' => {
                'code' => '320',
                'message' => 'Invalid Expiration Date'
              }
            },
            {
              'orderId' => '10',
              'card' => {
                'type'=>'MC',
                'number' =>'5112000400400018',
                'expDate' =>'0210'
              },
              'response' => {
                'code' => '301',
                'message' => 'Invalid Account Number'
              }
            },
          ]
        }
      }
      hash = customer_hash.merge(TestSharedData.real_certification_hash)
      response = LitleRequest.new.account_updater_batch_request(hash)
      customer_hash['batchRequest']['accountUpdate'].each_with_index do |order, i|
        assert_equal(order['orderId'], response.batchResponse.accountUpdateResponse[i].orderId)
        assert_equal(order['response']['code'], response.batchResponse.accountUpdateResponse[i].response)
        assert_equal(order['response']['message'], response.batchResponse.accountUpdateResponse[i].message)
      end
    end
  end
end
