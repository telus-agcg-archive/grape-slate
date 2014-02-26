class GrapeSlate::ExampleGenerator::Shell
  attr_reader :route, :resource

  delegate :route_name, to: :route
  delegate :host, :request_headers, to: 'GrapeMarkdown::Configuration'

  def initialize(route, resource)
    @route    = route
    @resource = resource
  end

  def lines
    @lines ||= [command, request, data, headers, verbose].flatten.compact
  end

  def example_binding
    binding
  end

  private

  def method
    route.route_method
  end

  def command
    "curl #{host}/#{route_name}/#{id}"
  end

  def request_by_id?
    method == 'GET' && !route.list? || %w(PUT DELETE).include?(method)
  end

  def id
    return unless request_by_id?

    GrapeMarkdown::Configuration.generate_id
  end

  def request
    return unless %w(POST PUT DELETE).include?(method)

    "--request #{method}"
  end

  def data
    "--data '#{resource.sample_request(false)}'"
  end

  def headers
    request_headers.map { |header| "--header '#{header.first.join(': ')}'" }
  end

  def verbose
    '--verbose'
  end
end