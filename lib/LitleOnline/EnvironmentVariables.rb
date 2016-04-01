module LitleOnline
  module EnvironmentVariables
    def self.default
      {
        'user' => '',
        'password' => '',
        'currency_merchant_map' => {
          'DEFAULT' => 'default'
        },
        'default_report_group' => 'Default Report Group',
        'url' => '',
        'proxy_addr' => '',
        'proxy_port' => '',
        'sftp_username' => '',
        'sftp_password' => '',
        'sftp_url' => '',
        'fast_url' => '',
        'fast_port' => '',
        'printxml' => false,
        'timeout' => 65
    }
    end
  end
end
