module Qcloud
  class Vod < Service
    def initialize(secret_id, secret_key)
      super("vod.tencentcloudapi.com", "", secret_id, secret_key)
    end

    def pull_events(**params)
      req = post("PullEvents", "2018-07-17", params)
      JSON.parse(req.body)
    end

    def confirm_events(event_handles, **params)
      raise "event_handles length must less or equal than 16" if event_handles.length > 16
      event_handles.each_with_index do |event_handle, i|
        params["EventHandles.#{i}"] = event_handle
      end
      req = post("ConfirmEvents", "2018-07-17", params)
      JSON.parse(req.body)
    end
  end
end
