require 'grape-markdown'

module GrapeSlate
  autoload :Version,         'grape-slate/version'
  autoload :Config,          'grape-slate/config'
  autoload :SampleGenerator, 'grape-slate/sample_generator'
  autoload :Document,        'grape-slate/document'

  def self.config
    block_given? ? yield(Config) : Config
  end

  class UnsupportedIDType < StandardError
    def message
      'Unsupported id type, supported types are [integer, uuid, bson]'
    end
  end

  class BSONNotDefinied < StandardError
    def message
      'BSON type id requested but bson library is not present'
    end
  end
end