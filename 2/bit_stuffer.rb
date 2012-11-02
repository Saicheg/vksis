require_relative 'package'

class BitStuffer
  class << self
    def stuff(data)
      data.unshift(flag).flatten!# For test purposes
      data.unshift(flag).flatten!# For test purposes
      data.unshift(flag).flatten!# For test purposes
      insert(data) if contains_flag?(data)
    end

    def unstuff(data)
      take_out(data)
    end

    def contains_flag?(data)
      0.upto(data.size-8) do |i|
        return true if data[i..i+7] == flag
      end
      false
    end

    private

    def insert(data)
      count = flag.group_by{|i| i}[1].count # number of 1
      result = [] << data[0..count-1]
      count.upto(data.size-1) do |i|
        result << 1 if data[i-count..i-1].inject(:+) == count
        result << data[i]
      end
      binding.pry
      result.flatten
      take_out(result.flatten)
    end

    def take_out(data)
      count = flag.group_by{|i| i}[1].count # number of 1
      result = [] << data[0..count-1]
      detected = false
      count.upto(data.size-1) do |i|
        if data[i-count..i-1].inject(:+) == count || detected
          detected = !detected
          next
        end
        result << data[i]
      end
      binding.pry
      result.flatten
     end

    def flag
      Package::FLAG.to_bit_arr
    end
  end
end
