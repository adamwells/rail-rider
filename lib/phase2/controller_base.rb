require 'active_support/inflector'

module Phase2
  class ControllerBase
    attr_reader :req, :res, :params

    # Setup the controller
    def initialize(req, res, route_params = {})
      @req, @res = req, res
      @already_built = false
      @params = Params.new(@req, route_params)
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      !!@already_built
    end

    # Set the response status code and header
    def redirect_to(url)
      raise if already_built_response?
      @res.status = 302
      @res.header['location'] = url
      @already_built = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
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

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end

    def flash
      @flash ||= Flash.new(@session)
    end

    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send(name)
    end
  end
end
