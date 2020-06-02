require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response
    attr_writer :headers

    def initialize(env)
      @name = extract_name
      @headers = {}
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params_from_path)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      add_params(params_from_path)

      send(action)
      write_response
      write_headers

      @response
    end

    def render_error
      default_header
      status(404)
      @response
    end

    private

    def add_params(params)
      params.each do |key, value|
        @request.update_param(key, value)
      end
    end

    def write_headers
      default_header
      @headers.each { |header_key, header_value| @response.set_header(header_key, header_value) }
    end

    def status(code)
      @response.status = code
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def default_header
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

  end
end
