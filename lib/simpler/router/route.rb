module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && compare_with_url(path)
      end

      def params(env)
        requested_url = env['PATH_INFO']
        params_values = differ_parts(requested_url)
        params_from_url = {}

        params_in_path.each_with_index do |param, index|
          params_from_url[param.gsub(':', '').to_sym] = params_values[index]
        end

        params_from_url
      end

      private

      def compare_with_url(requested_url)
        params_values = differ_parts(requested_url)
        params_values.empty? || params_values.count == params_in_path.count
      end

      def url_parts(url)
        url.scan(/(?<=\/)\w+(?<!\/\b)/)
      end

      def params_in_path
        @path.scan(/(?<=\/):\w+(?<!\/\b)/)
      end

      def path_parts
        @path.scan(/(?<=\/)\w+(?<!\/\b)/)
      end

      def differ_parts(url)
        url_parts(url) - path_parts
      end

    end
  end
end
