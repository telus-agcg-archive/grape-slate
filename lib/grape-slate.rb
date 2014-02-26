require 'grape-markdown'

module GrapeSlate
  autoload :Version,          'grape-slate/version'
  autoload :SampleGenerator,  'grape-slate/sample_generator'
  autoload :Document,         'grape-slate/document'
  autoload :ExampleGenerator, 'grape-slate/example_generator'

  def self.config
    if block_given?
      yield(GrapeMarkdown::Configuration)
    else
      GrapeMarkdown::Configuration
    end
  end
end

GrapeMarkdown::Configuration.extend :host
