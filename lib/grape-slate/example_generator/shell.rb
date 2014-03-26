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

  def route_path
    route.route_path_without_format
  end

  def command
    path = route_path.split('/').reject!(&:empty?).join('/')
    "curl #{host}/#{path}"
  end

  def request_by_id?
    method == 'GET' && !route.list? || %w(PUT DELETE).include?(method)
  end

  def request
    return unless %w(POST PUT DELETE).include?(method)

    "--request #{method}"
  end

  def data
    return unless %w(POST PUT).include?(method)

    "--data '#{resource.sample_request(false)}'"
  end

  def headers
    request_headers.map { |header| "--header '#{header.first.join(': ')}'" }
  end

  def verbose
    '--verbose'
  end
end
