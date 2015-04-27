class FaviconsController < ApplicationController
  def get
    # TODO: stop caching the default image
    data = $disk_store.fetch(request_hash) do
      fetch_favicon(params[:url])
    end

    # ask client to cache for one day
    response.headers['Expires'] = 1.day.from_now.httpdate

    send_data data.read, type: 'image/x-icon', disposition: 'inline'
  end

  private

    def request_hash
      @request_hash ||= Digest::SHA1.hexdigest(params[:url])
    end

    def fetch_favicon(url)
      StringIO.new(Faviconduit.get(url).data)
    rescue
      # this will end up caching the default image repeatedly. *shrug*
      open(Rails.root.join('public', 'images', 'default_favicon.png'))
    end
end
