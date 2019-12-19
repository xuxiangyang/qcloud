require 'cgi'
module Qcloud
  class Live < Service
    def initialize(secret_id, secret_key)
      super("live.tencentcloudapi.com", "", secret_id, secret_key)
    end

    def create_live_record(stream_name, start_time: Time.now, end_time: Time.now + 86400, **params)
      params["StreamName"] = stream_name
      params["StartTime"] = CGI.escape(start_time.strftime("%Y-%m-%d %H:%M:%S")).downcase
      params["EndTime"] = CGI.escape(end_time.strftime("%Y-%m-%d %H:%M:%S")).downcase
      req = post("CreateLiveRecord", "2018-08-01", params)
      JSON.parse(req.body)
    end

    def stop_live_record(stream_name, task_id)
      params = {
        StreamName: stream_name,
        TaskId: task_id,
      }
      req = post("StopLiveRecord", "2018-08-01", params)
      JSON.parse(req.body)
    end

    def delete_live_record(stream_name, task_id)
      params = {
        StreamName: stream_name,
        TaskId: task_id,
      }
      req = post("DeleteLiveRecord", "2018-08-01", params)
      JSON.parse(req.body)
    end
  end
end
