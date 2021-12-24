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

    def create_common_mix_stream(mix_stream_session_id:, input_stream_list:, output_params:, mix_stream_template_id: 0, control_params: {})
      params = {
        MixStreamSessionId: mix_stream_session_id,
        InputStreamList: input_stream_list,
        OutputParams: output_params,
        MixStreamTemplateId: mix_stream_template_id,
        ControlParams: control_params,
      }.deep_transform_keys { |k| k.to_s.camelize }

      req = post("CreateCommonMixStream", "2018-08-01", params)
      JSON.parse(req.body)
    rescue JSON::ParserError => e
      raise JsonParseError.new(e.message, req.body)
    end

    def cancel_common_mix_stream(mix_stream_session_id)
      params = {
        MixStreamSessionId: mix_stream_session_id,
      }.deep_transform_keys { |k| k.to_s.camelize }

      req = post("CancelCommonMixStream", "2018-08-01", params)
      JSON.parse(req.body)
    end
  end
end
