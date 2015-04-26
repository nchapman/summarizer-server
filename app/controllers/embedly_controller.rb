require 'digest/sha1'

class EmbedlyController < ApplicationController
  def extract
    result = $redis.get(request_hash)

    if result.nil?
      result = embedly_extract

      $redis.set(request_hash, result)
      $redis.expire(request_hash, 1.day)
    end

    render json: result
  end

  private

    def request_hash
      @request_hash = Digest::SHA1.hexdigest(request.GET.to_json)
    end

    def embedly_extract
      RestClient.get('https://api.embed.ly/1/extract', { params: request.GET.merge(key: Rails.application.secrets.embedly_key) })
    end
end
