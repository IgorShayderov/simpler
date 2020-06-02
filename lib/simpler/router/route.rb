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
        p compare_url(path)
        @method == method && compare_url(path)
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

      def compare_url(path)
        success = true
        request_parts = url_parts(path)
        return false if request_parts.count != path_parts.count

        path_parts.each_with_index do |part, index|
          if part[0] != ':'
            success = false if part != request_parts[index]
          end
        end

        success
      end

      def url_parts(url)
        url.scan(/(?<=\/)\w+(?<!\/\b)/)
      end

      def params_in_path
        @path.scan(/(?<=\/):\w+(?<!\/\b)/)
      end

      def path_parts
        @path.scan(/(?<=\/):?\w+(?<!\/\b)/)
      end

      def differ_parts(url)
        url_parts(url) - path_parts
      end

    end
  end
end
