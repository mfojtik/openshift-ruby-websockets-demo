Bundler.require(:default)
load './timeserver.rb'

Faye::WebSocket.load_adapter('puma')

run Rack::URLMap.new('/' => TimeServer.new.to_app)
