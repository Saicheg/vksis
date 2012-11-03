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

  def to_int_arr
    self.each_slice(8).map{|arr| arr.join("").to_i(2)}
  end

  def to_bit_str
    self.to_int_arr.map(&:to_bit_arr).map{|arr| arr.join("")}.join("")
  end

  def to_string
    self.to_int_arr.pack("c*")
  end
end
