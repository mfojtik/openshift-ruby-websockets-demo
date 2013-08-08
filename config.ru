Bundler.require(:default)
load './app.rb'

Faye::WebSocket.load_adapter('puma')

# The default OpenShift websockets port is '8000' where in your local
# environment you will use default puma port which is 9292
#
ENV['WEBSOCKET_PORT'] = ENV['OPENSHIFT_RUBY_PORT'].nil? ? '9292' : '8000'

# This is needed to have Puma bind on the right IP address and port:
#
run Rack::URLMap.new("/time" => TimeApp, "/" => WebSocketApp)
