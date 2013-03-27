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
require_relative 'Configuration'

#
# This class does all the heavy lifting of mapping the Ruby hash into Litle XML format
# It also handles validation looking for missing or incorrect fields
#contains the methods to properly create each batch type
#
module LitleOnline

  class LitleRequest
    attr_reader :num_batch_requests

    def initialize
      #load configuration data
      @config_hash = Configuration.new.config
    end

    def account_updater_batch_request(options)
      @num_batch_requests = 1
      batch = BatchRequest.from_hash(options)
      reportGroup = get_report_group(options)
      batch.accountUpdate.each { |accountUpdate| accountUpdate.reportGroup = reportGroup }
      batch.numAccountUpdates = get_num_account_updates(options)

      add_account_info(batch, options)

      commit(batch, :batch_request, options)
    end

    def account_updater_request_for_response(options)
      @num_batch_requests = 0
      batch = RFRRequest.new
      unless options['merchantId']
        options.merge!({'merchantId' => get_merchant_id(options)})
      end
      batch.accountUpdateFileRequestData = AccountUpdateFileRequestData.from_hash(options)

      commit(batch, :rfr_request, options)
    end

    private

    def add_account_info(batch, options)
      batch.merchantId = get_merchant_id(options)
    end

    def build_request(options)
      request = LitleRequest.new

      authentication = Authentication.new
      authentication.user     = get_config(:user, options)
      authentication.password = get_config(:password, options)

      request.authentication   = authentication
      request.version          = get_config(:version, options)
      request.xmlns            = "http://www.litle.com/schema"
      request.id               = get_id(options)
      request.numBatchRequests = get_num_batch_requests

      request
    end

    def commit(batch, type, options)
      configure_connection(options)

      request = build_request(options)

      request.send(:"#{type}=", batch)

      xml = request.save_to_xml.to_s
      LitleXmlMapper.request(xml, @config_hash)
    end

    def configure_connection(options={})
      @config_hash['proxy_addr'] = options['proxy_addr'] unless options['proxy_addr'].nil?
      @config_hash['proxy_port'] = options['proxy_port'] unless options['proxy_port'].nil?
      @config_hash['url']        = options['url']        unless options['url'].nil?
    end

    def get_merchant_id(options)
      options['merchantId'] || @config_hash['currency_merchant_map']['DEFAULT']
    end

    def get_report_group(options)
      options['reportGroup'] || @config_hash['default_report_group']
    end

    def get_config(field, options)
      options[field.to_s] == nil ? @config_hash[field.to_s] : options[field.to_s]
    end
    
    def get_logged_in_user(options)
      options['loggedInUser'] || nil
    end

    def get_id(options)
      options['id'] || nil
    end

    def get_num_batch_requests
      num_batch_requests || 1
    end

    def get_num_account_updates(options)
      options['batchRequest']['accountUpdate'].length
    end
  end
end
