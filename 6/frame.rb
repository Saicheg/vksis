require 'digest/crc32'

class Frame
  attr_accessor :access, :destination, :source, :data, :status, :token, :priority, :reserved, :ttl

  def initialize
    @token = true
    @status = false
    @priority = 8
    @reserved = 0
    @ttl = 2
  end

  def info
    if token
      "token"
    else
      "Destination: #{@destination}, source: #{@source}, data: #{@data}, status: #{status}, priority: #{@priority}, reserved: #{@reserved}"
    end
  end

  def fcs
    @fcs ||= Digest::CRC32.hexdigest("#{@destination} #{@source} #{@data} #{@priority}")
  end

end
