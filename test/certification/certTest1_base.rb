require 'lib/LitleOnline'

#require 'Litle_activemerchant'
require 'test/unit'

class Litle_certTest < Test::Unit::TestCase
  @@merchant_hash = {'reportGroup'=>'Planets',
    'merchantId'=>'101'
  }
  def test_1
    customer_hash = {
      'orderId' => '1',
      'amount' => '10010',
      'orderSource'=>'ecommerce',
      'billToAddress'=>{
      'name' => 'John Smith',
      'addressLine1' => '1 Main St.',
      'city' => 'Burlington',
      'state' => 'MA',
      'zip' => '01803-3747',
      'country' => 'US'},
      'card'=>{
      'number' =>'4457010000000009',
      'expDate' => '0112',
      'cardValidationNum' => '349',
      'type' => 'VI'}
    }
    hash = customer_hash.merge(@@merchant_hash)
    auth_response = LitleOnlineRequest.new.authorization(hash)
    assert_equal('000', auth_response.authorizationResponse.response)
    assert_equal('Approved', auth_response.authorizationResponse.message)
    assert_equal('11111 ', auth_response.authorizationResponse.authCode)
    assert_equal('01', auth_response.authorizationResponse.fraudResult.avsResult)
    assert_equal('M', auth_response.authorizationResponse.fraudResult.cardValidationResult)

    #test 1A
    capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '10'}
    hash1a = capture_hash.merge(@@merchant_hash)
    capture_response = LitleOnlineRequest.new.capture(hash1a)
    assert_equal('000', capture_response.captureResponse.response)
    assert_equal('Approved', capture_response.captureResponse.message)

    #test 1B
    credit_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId, 'amount' => '100' }
    hash1b = credit_hash.merge(@@merchant_hash)
    credit_response = LitleOnlineRequest.new.credit(hash1b)
    assert_equal('000', credit_response.creditResponse.response)
    assert_equal('Approved', credit_response.creditResponse.message)

    #test1C
    void_hash =  {'litleTxnId' => credit_response.creditResponse.litleTxnId, 'amount' => '100' }
    hash1c = void_hash.merge(@@merchant_hash)
    void_response = LitleOnlineRequest.new.void(hash1c)
    assert_equal('000', void_response.voidResponse.response)
    assert_equal('Approved', void_response.voidResponse.message)
  end

  	def test_2
  		customer_hash = {
  		'orderId' => '2',
  		'amount' => '20020',
  		'orderSource'=>'ecommerce',
  		'billToAddress'=>{
  			'name' => 'Mike J. Hammer',
  			'addressLine1' => '2 Main St.',
  			'addressLine2' => 'Apt. 222',
  			'city' => 'Riverside',
  			'state' => 'RI',
  			'zip' => '02915',
  			'country' => 'US'},
  		'card'=>{
  			'number' =>'5112010000000003',
        'expDate' => '0212',
        'cardValidationNum' => '261',
        'type' => 'MC'
  		},
  		'cardholderAuthentication' => {'authenticationValue'=> 'BwABBJQ1AgAAAAAgJDUCAAAAAAA=' }
  		}
  	hash = customer_hash.merge(@@merchant_hash)
  	auth_response = LitleOnlineRequest.new.authorization(hash)
  	assert_equal('000', auth_response.authorizationResponse.response)
  	assert_equal('Approved', auth_response.authorizationResponse.message)
  	assert_equal('22222', auth_response.authorizationResponse.authCode)
  	#assert_equal('10', auth_response.authorizationResponse.fraudResult.avsResult)
  	assert_equal('M', auth_response.authorizationResponse.fraudResult.cardValidationResult)
  
  	#test 2A
  	capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
  	hash2a = capture_hash.merge(@@merchant_hash)
  	capture_response = LitleOnlineRequest.new.capture(hash2a)
  	assert_equal('000', capture_response.captureResponse.response)
  	assert_equal('Approved', capture_response.captureResponse.message)
  
  	#test 2B
  	credit_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId}
  	hash2b = credit_hash.merge(@@merchant_hash)
  	credit_response = LitleOnlineRequest.new.credit(hash2b)
  	assert_equal('000', credit_response.creditResponse.response)
  	assert_equal('Approved', credit_response.creditResponse.message)
  
  	#test 2C
  	void_hash =  {'litleTxnId' => credit_response.creditResponse.litleTxnId}
  	hash2c = void_hash.merge(@@merchant_hash)
  	void_response = LitleOnlineRequest.new.void(hash2c)
  	assert_equal('000', void_response.voidResponse.response)
  	assert_equal('Approved', void_response.voidResponse.message)
  	end

  	def test_3
  		customer_hash = {
  		'orderId' => '3',
  		'amount' => '30030',
  		'orderSource'=>'ecommerce',
  		'billToAddress'=>{
  			'name' => 'Eileen Jones',
  			'addressLine1' => '3 Main St.',
  			'city' => 'Bloomfield',
  			'state' => 'CT',
  			'zip' => '06002',
  			'country' => 'US'},
  		'card'=>{
  			'number' =>'6011010000000003',
        'expDate' => '0312',
  	  	'type' => 'DI',
  			'cardValidationNum' => '758'},
  		}
  	hash = customer_hash.merge(@@merchant_hash)
  	auth_response = LitleOnlineRequest.new.authorization(hash)
  	assert_equal('000', auth_response.authorizationResponse.response)
  	assert_equal('Approved', auth_response.authorizationResponse.message)
  	assert_equal('33333', auth_response.authorizationResponse.authCode)
  	assert_equal('10', auth_response.authorizationResponse.fraudResult.avsResult)
  	assert_equal('M', auth_response.authorizationResponse.fraudResult.cardValidationResult)
  
  	#test 3A
  	capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
  	hash2a = capture_hash.merge(@@merchant_hash)
  	capture_response = LitleOnlineRequest.new.capture(hash2a)
  	assert_equal('000', capture_response.captureResponse.response)
  	assert_equal('Approved', capture_response.captureResponse.message)
  
  
  	#test 3B
  	credit_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId}
  	hash2b = credit_hash.merge(@@merchant_hash)
  	credit_response = LitleOnlineRequest.new.credit(hash2b)
  	assert_equal('000', credit_response.creditResponse.response)
  	assert_equal('Approved', credit_response.creditResponse.message)
  
  	#test 3C
  	void_hash =  {'litleTxnId' => credit_response.creditResponse.litleTxnId}
  	hash2c = void_hash.merge(@@merchant_hash)
  	void_response = LitleOnlineRequest.new.void(hash2c)
  	assert_equal('000', void_response.voidResponse.response)
  	assert_equal('Approved', void_response.voidResponse.message)
  	end

    def test_4
      customer_hash = {
        'orderId' => '4',
        'amount' => '40040',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Bob Black',
        'addressLine1' => '4 Main St.',
        'city' => 'Laurel',
        'state' => 'MD',
        'zip' => '20708',
        'country' => 'US'},
        'card'=>{
        'number' =>'375001000000005',
        'expDate' => '0412',
        'type' => 'AX'
        },
      }
      hash = customer_hash.merge(@@merchant_hash)
      auth_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('000', auth_response.authorizationResponse.response)
      assert_equal('Approved', auth_response.authorizationResponse.message)
      assert_equal('44444', auth_response.authorizationResponse.authCode)
      assert_equal('12', auth_response.authorizationResponse.fraudResult.avsResult)
  
      #test 4A
      capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId}
      hash2a = capture_hash.merge(@@merchant_hash)
      capture_response = LitleOnlineRequest.new.capture(hash2a)
      #assert_equal('000', cardholderAuthenticationcapture_response.captureResponse.response)
      assert_equal('Approved', capture_response.captureResponse.message)
  
      #test 4B
      credit_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId}
      hash2b = credit_hash.merge(@@merchant_hash)
      credit_response = LitleOnlineRequest.new.credit(hash2b)
      assert_equal('000', credit_response.creditResponse.response)
      assert_equal('Approved', credit_response.creditResponse.message)
  
      #test 4C
      void_hash =  {'litleTxnId' => credit_response.creditResponse.litleTxnId}
      hash2c = void_hash.merge(@@merchant_hash)
      void_response = LitleOnlineRequest.new.void(hash2c)
      assert_equal('000', void_response.voidResponse.response)
      assert_equal('Approved', void_response.voidResponse.message)
    end

    	def test_5
    		customer_hash = {
    		'orderId' => '5',
    		'amount' => '50050',
    		'orderSource'=>'ecommerce',
    		'card'=>{
    			'number' =>'4457010200000007',
          'expDate' => '0512',
    			'cardValidationNum' => '463',
    			'type' => 'VI'},
    		'cardholderAuthentication' => {'authenticationValue'=> 'BwABBJQ1AgAAAAAgJDUCAAAAAAA=' }
    		}
    	hash = customer_hash.merge(@@merchant_hash)
    	auth_response = LitleOnlineRequest.new.authorization(hash)
    	assert_equal('000', auth_response.authorizationResponse.response)
    	assert_equal('Approved', auth_response.authorizationResponse.message)
    	assert_equal('55555 ', auth_response.authorizationResponse.authCode)
    	assert_equal('32', auth_response.authorizationResponse.fraudResult.avsResult)
    	#assert_equal('N', auth_response.authorizationResponse.fraudResult.cardValidationResult)
  
  
    	#test 5A
    	capture_hash =  {'litleTxnId' => auth_response.authorizationResponse.litleTxnId, 'amount' => '10'}
    	hash2a = capture_hash.merge(@@merchant_hash)
    	capture_response = LitleOnlineRequest.new.capture(hash2a)
    	assert_equal('000', capture_response.captureResponse.response)
    	assert_equal('Approved', capture_response.captureResponse.message)
  
    	#test 5B
    	credit_hash =  {'litleTxnId' => capture_response.captureResponse.litleTxnId, 'amount' => '100'}
    	hash2b = credit_hash.merge(@@merchant_hash)
    	credit_response = LitleOnlineRequest.new.credit(hash2b)
    	assert_equal('000', credit_response.creditResponse.response)
    	assert_equal('Approved', credit_response.creditResponse.message)
  
    	#test 5C
    	void_hash =  {'litleTxnId' => credit_response.creditResponse.litleTxnId, 'amount' => '100'}
    	hash2c = void_hash.merge(@@merchant_hash)
    	void_response = LitleOnlineRequest.new.void(hash2c)
    	assert_equal('000', void_response.voidResponse.response)
    	assert_equal('Approved', void_response.voidResponse.message)
    	end

    def test_6
      customer_hash = {
        'orderId' => '6',
        'amount' => '60060',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Joe Green',
        'addressLine1' => '6 Main St.',
        'city' => 'Derry',
        'state' => 'NH',
        'zip' => '03038',
        'country' => 'US'},
        'card'=>{
        'number' =>'4457010100000008',
        'expDate' => '0612',
        'type' => 'VI',
        'cardValidationNum' => '992'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      sale_response = LitleOnlineRequest.new.sale(hash)
      assert_equal('110', sale_response.saleResponse.response)
      assert_equal('Insufficient Funds', sale_response.saleResponse.message)
      assert_equal('34', sale_response.saleResponse.fraudResult.avsResult)
      assert_equal('P', sale_response.saleResponse.fraudResult.cardValidationResult)
  
      #test 6A
      void_hash =  {'litleTxnId' => sale_response.saleResponse.litleTxnId }
      hash6A = void_hash.merge(@@merchant_hash)
      void_response = LitleOnlineRequest.new.void(hash6A)
      assert_equal('360', void_response.voidResponse.response)
      assert_equal('No transaction found with specified litleTxnId', void_response.voidResponse.message)
    end

    def test_7
      customer_hash = {
        'orderId' => '7',
        'amount' => '70070',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Jane Murray',
        'addressLine1' => '7 Main St.',
        'city' => 'Amesbury',
        'state' => 'MA',
        'zip' => '01913',
        'country' => 'US'},
        'card'=>{
        'number' =>'5112010100000002',
        'expDate' => '0712',
        'cardValidationNum' => '251',
        'type' => 'MC'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      authorization_response = LitleOnlineRequest.new.authorization(hash)
      assert_equal('301', authorization_response.authorizationResponse.response)
      assert_equal('Invalid Account Number', authorization_response.authorizationResponse.message)
      assert_equal('34', authorization_response.authorizationResponse.fraudResult.avsResult)
      assert_equal('N', authorization_response.authorizationResponse.fraudResult.cardValidationResult)
    end

    def test_8
      customer_hash = {
        'orderId' => '8',
        'amount' => '80080',
        'orderSource'=>'ecommerce',
        'billToAddress'=>{
        'name' => 'Mark Johnson',
        'addressLine1' => '8 Main St.',
        'city' => 'Manchester',
        'state' => 'NH',
        'zip' => '03101',
        'country' => 'US'},
        'card'=>{
        'number' =>'6011010100000002',
        'expDate' => '0812',
        'type' => 'DI',
        'cardValidationNum' => '184'}
      }
      hash = customer_hash.merge(@@merchant_hash)
      sale_response = LitleOnlineRequest.new.sale(hash)
      assert_equal('123', sale_response.saleResponse.response)
      assert_equal('Call Discover', sale_response.saleResponse.message)
      #assert_equal('', auth_response.authorizationResponse.authCode)
      assert_equal('P', sale_response.saleResponse.fraudResult.cardValidationResult)
      assert_equal('34', sale_response.saleResponse.fraudResult.avsResult)
    end

    	def test_9
    		customer_hash = {
    		'orderId' => '9',
    		'amount' => '90090',
    		'orderSource'=>'ecommerce',
    		'billToAddress'=>{
    			'name' => 'James Miller',
    			'addressLine1' => '9 Main St.',
    			'city' => 'Boston',
    			'state' => 'MA',
    			'zip' => '02134',
    			'country' => 'US'},
    		'card'=>{
    			'number' =>'375001010000003',
    			'expDate' => '0912',
    			'cardValidationNum' => '0421',
    			'type' => 'AX'
    			}
    		}
    	hash = customer_hash.merge(@@merchant_hash)
    	sale_response = LitleOnlineRequest.new.authorization(hash)
    	assert_equal('303', sale_response.authorizationResponse.response)
    	assert_equal('Pick Up Card', sale_response.authorizationResponse.message)
    	#assert_equal('44444', auth_response.authorizationResponse.authCode)
    	#assert_equal('P', sale_response.authorizationResponse.fraudResult.cardValidationResult)
    	assert_equal('34', sale_response.authorizationResponse.fraudResult.avsResult)
    	end

    	def test_10
    		customer_hash = {
    		'orderId' => '10',
    		'amount' => '40000',
    		'orderSource'=>'ecommerce',
    		'card'=>{
    			'number' =>'4457010140000141',
    			'expDate' => '0912',
    			'type' => 'VI'
    			},
    		'allowPartialAuth' => 'true'
    		}
    	hash = customer_hash.merge(@@merchant_hash)
    	auth_response = LitleOnlineRequest.new.authorization(hash)
    	assert_equal('010', auth_response.authorizationResponse.response)
    	assert_equal('Partially Approved', auth_response.authorizationResponse.message)
    	assert_equal('32000', auth_response.authorizationResponse.approvedAmount)
    	end

    	def test_11
    		customer_hash = {
    		'orderId' => '11',
    		'amount' => '60000',
    		'orderSource'=>'ecommerce',
    		'card'=>{
    			'number' =>'5112010140000004',
    			'expDate' => '1111',
    			'type' => 'MC'
    			},
    		'allowPartialAuth' => 'true'
    		}
    	hash = customer_hash.merge(@@merchant_hash)
    	auth_response = LitleOnlineRequest.new.authorization(hash)
    	assert_equal('010', auth_response.authorizationResponse.response)
    	assert_equal('Partially Approved', auth_response.authorizationResponse.message)
    	assert_equal('48000', auth_response.authorizationResponse.approvedAmount)
    	end

    	def test_12
    		customer_hash = {
    		'orderId' => '12',
    		'amount' => '50000',
    		'orderSource'=>'ecommerce',
    		'card'=>{
    			'number' =>'375001014000009',
    			'expDate' => '0412',
    			'type' => 'AX'},
    		'allowPartialAuth' => 'true'
    		}
    	hash = customer_hash.merge(@@merchant_hash)
    	auth_response = LitleOnlineRequest.new.authorization(hash)
    	assert_equal('010', auth_response.authorizationResponse.response)
    	assert_equal('Partially Approved', auth_response.authorizationResponse.message)
    	assert_equal('40000', auth_response.authorizationResponse.approvedAmount)
    	end

  def test_13
    customer_hash = {
      'orderId' => '13',
      'amount' => '15000',
      'orderSource'=>'ecommerce',
      'card'=>{
      'number' =>'6011010140000004',
      'expDate' => '0812',
      'type' => 'DI'},
      'allowPartialAuth' => 'true'
    }
    hash = customer_hash.merge(@@merchant_hash)
    auth_response = LitleOnlineRequest.new.authorization(hash)
    assert_equal('010', auth_response.authorizationResponse.response)
    assert_equal('Partially Approved', auth_response.authorizationResponse.message)
    assert_equal('12000', auth_response.authorizationResponse.approvedAmount)
  end
end