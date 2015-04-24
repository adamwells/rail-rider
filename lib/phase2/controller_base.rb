require 'active_support/inflector'

module Phase2
  class ControllerBase
    attr_reader :req, :res, :params

    def initialize(req, res, route_params = {})
      @req, @res = req, res
      @already_built = false
      @params = Params.new(@req, route_params)
    end

    def already_built_response?
      !!@already_built
    end

    def redirect_to(url)
      raise if already_built_response?
      @res.status = 302
      @res.header['location'] = url
      @already_built = true
    end

    def render_content(content, content_type)
      raise if already_built_response?
      @res.content_type = content_type
      @res.body = content
      @already_built = true
    end

    def render(template_name)
      f = File.read("views/#{self.class.name.underscore}/#{template_name}.html.erb")
      template = ERB.new(f)
      self.render_content(template.result(binding), 'text/html')
    end

    def redirect_to(url)
      super
      session.store_session(@res)
      flash.now ||= {}
    end

    def render_content(content, content_type)
      super
      session.store_session(@res)
    end

    def session
      @session ||= Session.new(@req)
    end

    def flash
      @flash ||= Flash.new(@session)
    end

    def invoke_action(name)
      self.send(name)
    end
  end
end
