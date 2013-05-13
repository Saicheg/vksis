class Frame
  attr_accessor :access, :destination, :source, :data, :fcs, :status, :token

  def initialize
    @token = true
    @status = false
  end

  def info
    if token
      "token"
    else
      "Destination: #{@destination}, source: #{@source}, data: #{@data}, status: #{status}"
    end
  end

end
