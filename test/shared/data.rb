module LitleOnline
  class TestSharedData

    CERTIFICATION_URL = 'https://cert.litle.com:15000'

    # NOTE:
    # The sandbox is unable (for now) to mimic batch processing,
    # so the tests need to go against the real certification system.
    # .litle_SDK_config.yml must have a real username and password.
    def self.real_certification_hash
      {
        'url'=>CERTIFICATION_URL
      }
    end
  end
end
