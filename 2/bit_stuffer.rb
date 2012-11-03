require_relative 'package'

class BitStuffer

  FLAG = 126 # 01111110
  FLAG_REPLACE = 254 # 011111110

  class << self
    def stuff(data)
      insert(data)
    end

    def unstuff(data)
      take_out(data)
    end

    def contains_flag?(data)
      data.to_bit_str.include?(flag_bit_str)
    end

    private

    def insert(data)
      data_str = data.join("")
      processed = data_str.gsub(flag_bit_str, flag_replace_bit_str)
      processed.split("").map(&:to_i)
    end

    def take_out(data)
      data_str = data.join("")
      processed = data_str.gsub(flag_replace_bit_str, flag_bit_str)
      processed.split("").map(&:to_i)
    end

    def flag_bit_str
      FLAG.to_bit_arr.to_bit_str
    end

    def flag_replace_bit_str
      FLAG_REPLACE.to_bit_arr.unshift(0).join("")
    end
  end
end
