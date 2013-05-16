$ ->
  FIX = 11
  printFix = (str) ->
    add = FIX - "#{str}".length
    for i in [0..add]
      str += ' '
    str

  d = -> 100 + Math.random() * 20

  window.acks = {}

  class Packet
    constructor: (@sn, @an, @window, @syn, @ack, @fin, @data) ->

    trace: (direction) ->
      tr = $('<tr></tr>')
      td = $('<td></td>')
      tr.append(td.clone().text(direction))
      tr.append(td.clone().text(@data || '-'))
      tr.append(td.clone().text(@sn))
      tr.append(td.clone().text(@an))
      tr.append(td.clone().text(@window))
      tr.append(td.clone().text(@syn))
      tr.append(td.clone().text(@ack))
      tr.append(td.clone().text(@fin))
      $trace.append(tr)

#################################### SYN

    sendSyn: ->
      @trace('C1 sent')
      setTimeout \
        => @sendSynAck(),
        d()

    sendSynAck: ->
      @trace('C2 received')
      @ack = 1
      @an = @sn + 1
      @sn = SN2
      @trace('C2 sent')
      setTimeout \
        => @sendAck(),
        d()

    sendAck: ->
      @trace('C1 received')
      SN1 = @an
      @an = @sn + 1
      @sn = SN1
      @syn = 0
      @trace('C1 sent')
      setTimeout \
        => @trace('C2 received'); sendWindow(),
        d()

#################################### DATA TRANSFER

    sendFromC1: ->
      @trace('C1 sent')
      acks[@sn + 1] = setInterval \
        => @sendAckFromC2(),
        d()

    sendAckFromC2: ->
      if @sn == toTransmit[0][1]
        if Math.random() > ERR
          @trace('C2 received')
          $out.append @data
          @ack = 1
          @an = @sn + 1
          @sn = SN2
          @data = '-'
          @trace('C2 sent')
          setTimeout \
            => @receiveAckOnC1(),
            d()
        else
          @trace('C2 lost')
      else
        @trace('C2 dropped')

    receiveAckOnC1: ->
      @trace('C1 received')
      clearInterval acks[@an]
      acks[@an] = null
      toTransmit.shift()
      SN1 = @an
      if toTransmit.length > 0 && (WINDOW - 1) < toTransmit.length
        new Packet(toTransmit[WINDOW-1][1], 0, WINDOW, 0, 0, 0, toTransmit[WINDOW-1][0]).sendFromC1()
      else
        setTimeout \
          -> new Packet(SN1, 0, WINDOW, 0, 0, 1, '-').sendFinFromC1(),
          2 * d()

#################################### FIN

    sendFinFromC1: ->
      @trace('C1 sent')
      setTimeout \
        => @receiveFinOnC2(),
        d()

    receiveFinOnC2: ->
      @trace('C2 received')
      @ack = 1
      @fin = 0
      @an = @sn + 1
      @sn = SN2
      @trace('C2 sent')
      setTimeout \
        => @receiveFinAckOnC1(),
        d()

    receiveFinAckOnC1: ->
      @trace('C1 received')
      SN1 = @an
      ++SN2
      @sn = SN2
      @an = 0
      @ack = 0
      @fin = 1
      @trace('C2 sent')
      setTimeout \
        => @receiveFinOnC1(),
        d()

    receiveFinOnC1: ->
      @trace('C1 received')
      @ack = 1
      @fin = 0
      @an = @sn + 1
      @sn = SN1 + 2
      @trace('C1 sent')
      setTimeout \
        => @receiveFinAckOnC2(),
        d()

    receiveFinAckOnC2: ->
      @trace('C2 received')

#################################### INITIALIZATION

  window.WINDOW = 3    # number of packets
  window.ERR = 0.1     # error chance

  $in = $('.input')
  $out = $('.output')
  $trace = $('.trace')
  $btn = $('button')

  window.initConnection = ->
    window.SN1 = 32 # isn 1
    window.SN2 = 87 # isn 2

    new Packet(SN1, 0, WINDOW, 1, 0, 0).sendSyn()

  window.sendWindow = ->
    window.toTransmit = []
    toTransmit.push [char, SN1 + i] for char, i in $in.val()

    for pack in toTransmit[0...WINDOW]
      new Packet(pack[1], 0, WINDOW, 0, 0, 0, pack[0]).sendFromC1()

  $in.on 'change', ->
    initConnection()

  $btn.on 'click', ->
    $in.text('')
    $out.text('')
    $trace.find('tr:not(:first-child)').remove()

