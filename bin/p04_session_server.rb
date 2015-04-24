require 'webrick'
require_relative '../lib/controller_base'

class MyController < Phase2::ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    flash["count"] ||= 0
    flash["count"] += 1
    render :counting_show
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end

trap('INT') { server.shutdown }
server.start
