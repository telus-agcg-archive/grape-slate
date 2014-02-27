module GrapeSlate
  class Document < GrapeMarkdown::Document
    attr_reader :shell_template

    def initialize(api_class)
      super

      @shell_template = template_for(:shell)
    end

    def shell_example(route, resource)
      example = ExampleGenerator::Shell.new(route, resource)

      render(shell_template, example.example_binding)
    end

    private

    def template_for(name)
      directory = File.dirname(File.expand_path(__FILE__))

      File.read(File.join(directory, "./templates/#{name}.md.erb"))
    end
  end
end
