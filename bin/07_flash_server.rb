require 'webrick'
require_relative '../lib/phase6/controller_base'
require_relative '../lib/phase6/router'

class Controller < Phase6::ControllerBase
  def index
    flash.now ||= 1
    flash.now += 1
  end
end

router = Phase6::Router.new

server = WEBrick::HTTPServer.new(:Port => 3000)

trap('INT') { server.shutdown }
server.start
