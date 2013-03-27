require 'lib/LitleOnline'
require 'test/unit'
require 'mocha'

module LitleOnline

  class LitleRequestTest < Test::Unit::TestCase
    def test_set_merchant_id
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}})
      litle = LitleRequest.new
      assert_equal '2', litle.send(:get_merchant_id, {'merchantId'=>'2'})
      assert_equal '1', litle.send(:get_merchant_id, {'NotMerchantId'=>'2'})
    end
  
    def test_account_updater_simple
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(regexp_matches(/<litleRequest .*/m),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_batch_request(batch_request_approved)
    end
  
    def test_account_updater_attributes
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      hash=batch_request_approved.merge({'reportGroup'=>'Planets'})
      Communications.expects(:http_post).with(regexp_matches(/.*<accountUpdate ((reportGroup="Planets")|(reportGroup="Planets")).*/m),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_batch_request(hash)
    end
  
    def test_account_updater_elements
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(regexp_matches(/.*<accountUpdate.*<orderId>1.*<type>VI.*<number>4457010000000009.*<expDate>0912.*/m),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_batch_request(batch_request_approved)
    end
  
    def test_capture_amount_should_not_be_in_account_updater_xml
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(Not(regexp_matches(/.*amount.*/m)),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_batch_request(batch_request_approved)
    end
  
    def test_account_updater_choice_between_card_token
      token_only = {
        'token'=> {
          'litleToken' => '1111222233334444',
          'expDate' =>'0912'
        }
      }
      hash = batch_request_approved
      hash['batchRequest']['accountUpdate'][0].delete('card')
      hash['batchRequest']['accountUpdate'][0].update(token_only)
      XMLObject.expects(:new)
      Communications.expects(:http_post).with(regexp_matches(/.*token.*/m),kind_of(Hash))
      LitleRequest.new.account_updater_batch_request(hash)
    end
    
    def test_account_updater_rfr_simple
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(regexp_matches(/<litleRequest .*/m),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_request_for_response(rfr_request)
    end
  
    def test_account_updater_rfr_attributes
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(regexp_matches(/<litleRequest .*numBatchRequests="0".*/m),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_request_for_response(rfr_request)
    end
  
    def test_account_updater_rfr_elements
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(regexp_matches(/.*<RFRRequest.*<accountUpdateFileRequestData.*<merchantId>1.*<postDay>2013-03-12.*/m),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_request_for_response(rfr_request)
    end
  
    def test_capture_amount_should_not_be_in_account_updater_rfr_xml
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(Not(regexp_matches(/.*amount.*/m)),kind_of(Hash))
      XMLObject.expects(:new)
      response = LitleRequest.new.account_updater_request_for_response(rfr_request)
    end
  
    private

    def rfr_request
      {
        'accountUpdateFileRequestData' => {
          'postDay' => '2013-03-12'
        }
      }
    end

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
  end
end
