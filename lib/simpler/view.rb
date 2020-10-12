require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template && template.class == Hash
        send("render_#{template.keys[0]}")
      else
        render_html(binding)
      end
    end

    private

    def render_plain
      template[:plain]
    end

    def render_html(binding)
      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
