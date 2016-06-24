require "redis"

module Ankusa
  class RedisStorage
    attr_reader :redis

    def initialize(redis = Redis.new)
      @redis = redis
      # reset
    end

    def classnames
      redis.hkeys("ankusa:doc_counts").map(&:to_sym)
    end

    # def reset
    #   drop_tables
    # end

    def drop_tables
      # redis.keys("ankusa:freqs:*").each do |key|
      #   redis.del key
      # end
      #
      # [:word_counts, :doc_counts, :vocabulary_size].each do |key|
      #   redis.del "ankusa:#{key}"
      # end
    end

    def init_tables
      drop_tables
    end

    def save
    end

    def get_vocabulary_sizes
      map_value redis.hgetall("ankusa:vocabulary_size")
    end

    def get_word_counts(word)
      map_value redis.hgetall("ankusa:freqs:#{word}")
    end

    def get_total_word_count(klass)
      redis.hget("ankusa:word_counts", klass).to_i
    end

    def get_doc_count(klass)
      redis.hget("ankusa:doc_counts", klass).to_i
    end

    def incr_word_count(klass, word, count)
      redis.hincrby("ankusa:vocabulary_size", klass, 1) unless redis.hexists("ankusa:freqs:#{word}", klass)
      redis.hincrby("ankusa:freqs:#{word}", klass, count).to_i
    end

    def incr_total_word_count(klass, count)
      redis.hincrby("ankusa:word_counts", klass, count).to_i
    end

    def incr_doc_count(klass, count)
      redis.hincrby("ankusa:doc_counts", klass, count).to_i
    end

    def doc_count_totals
      map_value redis.hgetall("ankusa:doc_counts")
    end

    def close
    end

    private
    def map_value(hash)
      hash.map{|key, value| { key.to_sym => value.to_i } }.inject({}, :merge)
    end
  end
end
