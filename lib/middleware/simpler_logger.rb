require 'logger'

class SimplerLogger
  STATUS_MESSAGES = {
    200 => 'OK',
    404 => 'Not Found'
  }.freeze

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @response = @app.call(env)
    @request = Rack::Request.new(env)
    @logger.info([request, handler, parameters, response].join("\n"))
    @response.finish
  end

  private

  def request
    "\nRequest: #{@request.request_method} #{@request.path}#{@request.query_string}"
  end

  def handler
    "Handler: #{@request.env['simpler.controller'].class.name}##{@request.env['simpler.action']}"
  end

  def parameters
    "Parameters: #{@request.params}"
  end

  def response
    "Response: #{@response.status} #{STATUS_MESSAGES[@response.status]} [#{@response.content_type}] #{@response.location}"
  end
end
