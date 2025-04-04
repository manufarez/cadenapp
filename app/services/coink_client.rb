require 'faraday'

class CoinkClient
  BASE_URL = 'https://api.coink.com'

  def initialize
    fixie_uri = URI.parse(ENV['FIXIE_URL'])

    @connection = Faraday.new(url: BASE_URL) do |conn|
      conn.proxy = {
        uri: fixie_uri.to_s,
        user: fixie_uri.user,
        password: fixie_uri.password
      }

      conn.request :json
      conn.response :json, parser_options: { symbolize_names: true }
      conn.adapter Faraday.default_adapter
    end
  end

  private

  def handle_response(response)
    if response.success?
      response.body
    else
      Rails.logger.error("[CoinkClient] Error: #{response.status} - #{response.body}")
      raise StandardError, "Coink API error (#{response.status})"
    end
  end
end
