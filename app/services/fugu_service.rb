# frozen_string_literal: true

class FuguService
  def self.track(name, properties = {})
    return unless ENV.fetch("FUGU_URL", nil)

    return if Rails.env.test?

    body = {
      api_key: ENV.fetch("FUGU_API_KEY", nil),
      name: name,
      properties: properties
    }

    begin
      Faraday.post(ENV.fetch("FUGU_URL", nil)) do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = body.to_json
      end
    rescue StandardError => e
      logger = Logger.new(STDOUT)
      logger.error("Error while calling Fugu API: #{e}")
    end
  end
end
