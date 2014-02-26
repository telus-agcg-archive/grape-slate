module GrapeSlate
  class Document < GrapeMarkdown::Document
    attr_reader :shell_template

    def initialize(api_class)
      @api_class           = api_class
      @document_template   = template_for(:document)
      @properties_template = template_for(:properties)
    end

    def generate
      ERB.new(document_template, nil, '-').result(binding)
    end

    def write
      fail 'Not yet supported'
    end

    def routes
      @routes ||= api_class.routes.map do |route|
        GrapeMarkdown::Route.new(route)
      end
    end

    def resources
      @resources ||= begin
        grouped_routes = routes.group_by(&:route_name).reject do |name, routes|
          resource_exclusion.include?(name.to_sym)
        end

        grouped_routes.map do |name, routes|
          GrapeMarkdown::Resource.new(name, routes)
        end
      end
    end

      @shell_template = template_for(:shell)
    end

    def shell_example(route, resource)
      example = ExampleGenerator::Shell.new(route, resource)

      render(shell_template, example.example_binding)
    end

    private

    def template_for(name)
      directory = File.dirname(File.expand_path(__FILE__))
      path = File.join(directory, "./templates/#{name}.md.erb")

      File.read(path)
    end

    def formatted_headers(headers)
      return '' unless headers.present?

      spacer  = "\n" + (' ' * 12)

      strings = headers.map do |header|
        key, value = *header.first

        "#{key}: #{value}"
      end

      "    + Headers\n" + spacer + strings.join(spacer)
    end
  end
end
