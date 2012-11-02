class Integer
  def to_bit_arr
    arr = self.to_s(2).split("").map(&:to_i)
    arr.unshift(0) while arr.size != 8
    arr
  end
end

class String
  def to_byte_arr
    self.unpack("C*").map(&:to_bit_arr).flatten
  end
end

class Array
  def to_string
    self.each_slice(8).map{|arr| arr.join("").to_i(2)}.pack("c*")
  end
end
