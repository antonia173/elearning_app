require 'xapi'

module XapiMethods
  extend ActiveSupport::Concern

  def remote_lrs
    Xapi.create_remote_lrs(end_point: 'https://elearningapp.lrs.io/xapi/', user_name: ENV['XAPI_USERNAME'], password: ENV['XAPI_PASSWORD'] )
  end

  def send_statment(verb:, verb_id:, object:, object_id:, object_description:, activity_type:, response:, success:, score_details:)
    agent = Xapi.create_agent(agent_type: 'Agent', email: current_user.email, name: current_user.first_name + " " + current_user.last_name)
    verb = Xapi.create_verb(id: verb_id, name: verb)
    object = Xapi.create_activity(id: object_id, name: object, type: activity_type, description: object_description, extensions: {})
    result = Xapi.create_result(response: response, success: success, score_details: score_details)
    result.success = success

    statement = Xapi.create_statement(actor: agent, verb: verb, object: object, result: result)
    response = Xapi.post_statement(remote_lrs: remote_lrs, statement: statement)
    if response.success
      Rails.logger.info("Statment posted successfully!")
    else   
      Rails.logger.error("Statment post failed")
    end
  end
end
