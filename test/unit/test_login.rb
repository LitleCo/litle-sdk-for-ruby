=begin
Copyright (c) 2013 Litle & Co.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end
require 'lib/LitleOnline'
require 'test/unit'
require 'mocha'

module LitleOnline
  class TestLogin < Test::Unit::TestCase
    def setup
      LitleOnline::Configuration.logger = nil
    end

    def teardown
      # To make sure we don't modify the global state for other tests
      LitleOnline::Configuration.logger = nil
    end

    def test_printxml_can_be_turned_on_by_setting_value_to_true
      ["printxml: 'true'", "printxml: Y", "printxml: true", "printxml: Yes", "printxml: ON"].each do |printxml_value|
        yaml = <<-EOYAML
user: 'a'
password: 'b'
currency_merchant_map:
    DEFAULT: '1'
version: '8.10'
#{printxml_value}
EOYAML
        Configuration.any_instance.stubs(:config).returns(YAML.load(yaml))
        Communications.expects(:http_post).with(kind_of(String),kind_of(Hash)).returns('<litleOnlineResponse><voidResponse><recycling><creditLitleTxnId>65</creditLitleTxnId></recycling></voidResponse></litleOnlineResponse>')
        Logger.any_instance.expects(:debug).with(kind_of(String)).twice
        hash={
          'litleTxnId' => '123'
        }

        response = LitleOnlineRequest.new.void(hash)
        logger = Logger.new(STDOUT)
        logger.level = Logger::DEBUG
        assert_equal logger.level, Configuration.logger.level
        assert_equal logger.sev_threshold, Configuration.logger.sev_threshold
      end
    end

    def test_printxml_can_be_turned_off_by_setting_value_to_false
      ["printxml: 'false'", "printxml: false", "printxml: n", "printxml: FALSE", "printxml: No", "printxml: off"].each do |printxml_value|
        yaml = <<-EOYAML
user: 'a'
password: 'b'
currency_merchant_map:
    DEFAULT: '1'
version: '8.10'
#{printxml_value}
EOYAML
        Configuration.any_instance.stubs(:config).returns(YAML.load(yaml))
        Communications.expects(:http_post).with(kind_of(String),kind_of(Hash)).returns('<litleOnlineResponse><voidResponse><recycling><creditLitleTxnId>65</creditLitleTxnId></recycling></voidResponse></litleOnlineResponse>')
        Logger.any_instance.expects(:debug).with(kind_of(String)).twice
        hash={
          'litleTxnId' => '123'
        }

        response = LitleOnlineRequest.new.void(hash)
        logger = Logger.new(STDOUT)
        logger.level = Logger::INFO
        assert_equal logger.level, Configuration.logger.level
        assert_equal logger.sev_threshold, Configuration.logger.sev_threshold
      end
    end

    def test_printxml_can_be_turned_off_by_not_setting_value
      Configuration.any_instance.stubs(:config).returns({'currency_merchant_map'=>{'DEFAULT'=>'1'}, 'user'=>'a','password'=>'b','version'=>'8.10'})
      Communications.expects(:http_post).with(kind_of(String),kind_of(Hash)).returns('<litleOnlineResponse><voidResponse><recycling><creditLitleTxnId>65</creditLitleTxnId></recycling></voidResponse></litleOnlineResponse>')
      Logger.any_instance.expects(:debug).with(kind_of(String)).twice
      hash={
        'litleTxnId' => '123'
      }

      response = LitleOnlineRequest.new.void(hash)
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      assert_equal logger.level, Configuration.logger.level
      assert_equal logger.sev_threshold, Configuration.logger.sev_threshold
    end
  end
end
