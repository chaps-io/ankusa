require File.join File.dirname(__FILE__), 'classifier_base'
require 'ankusa/redis_storage'

module RedisClassifierBase
  def initialize(name)
    @storage = Ankusa::RedisStorage.new
    super name
  end
end

class NBFileSystemClassifierTest < Test::Unit::TestCase
  include RedisClassifierBase
  include NBClassifierBase
end


class KLFileSystemClassifierTest < Test::Unit::TestCase
  include RedisClassifierBase
  include KLClassifierBase
end
