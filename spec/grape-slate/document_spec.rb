require 'spec_helper'

describe GrapeSlate::Document do
  include_context 'configuration'

  before do
    GrapeSlate.config do |config|
      config.host               = host
      config.name               = name
      config.description        = description
      config.resource_exclusion = [:admin]
      config.include_root       = true
    end

    GrapeSlate.config.request_headers = [
      { 'Accept-Charset' => 'utf-8' },
      { 'Connection'     => 'keep-alive' }
    ]

    GrapeSlate.config.response_headers = [
      { 'Content-Length' => '21685' },
      { 'Connection'     => 'keep-alive' }
    ]
  end

  subject { GrapeSlate::Document.new(SampleApi) }

  context '#generate' do
    let(:klass) { SampleApi }

    subject { GrapeSlate::Document.new(klass).generate }

    it 'sets the title based on name' do
      expect(subject).to include("title: #{name} Reference")
    end

    it 'lists shell as the language type' do
      expect(subject).to include('  - shell')
    end

    it 'creates a header from configuration' do
      expect(subject).to include("# #{name}")
    end

    it 'adds the description' do
      expect(subject).to include(description)
    end

    it 'includes a headline for each resource' do
      expect(subject).to include('# Widgets')
    end

    it 'includes properties for the resources' do
      expect(subject).to include('Properties')
    end
  end
end
