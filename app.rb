# This is the WebSocket routing application:
#
WebSocketApp = lambda do |env|

  if Faye::WebSocket.websocket?(env)

    ws = Faye::WebSocket.new(env)

    # When client connects through WebSocket, then start sending the current
    # time in the Thread every 1s
    ws.on :open do |e|
      @clock = Thread.new { loop { ws.send(Time.now.to_s); sleep(1) } }
    end

    # Kill the thread when client disconnects and remove the websocket
    ws.on :close do |e|
      Thread.kill(@clock)
      ws = nil
    end

    ws.rack_response

  else
    # Redirect the client to the Sinatra application, if the request
    # is not WebSocket
    [301, { 'Location' => '/time'}, []]
  end
end

# Puma require the 'log' method for the server request logging:
#
def WebSocketApp.log(message); $stdout.puts message; end

# This is very basic Sinatra app that will just render the HTML with WebSocket
# javascript handling:
#
class TimeApp < Sinatra::Base

  get '/' do
    erb :index
  end

end
