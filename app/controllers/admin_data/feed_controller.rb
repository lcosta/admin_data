class AdminData::FeedController < AdminData::BaseController

  unloadable

  before_filter :ensure_is_allowed_to_view_feed

  def index
    render :text => "usage: http://localhost:3000/admin_data/feed/user" and return if params[:klasss].blank?

    begin
      @klass = AdminData::Util.camelize_constantize(params[:klasss])
    rescue NameError => e
      render :text => "No constant was found with name #{params[:klasss]}" and return
    end
  end

  private

  def ensure_is_allowed_to_view_feed
    #FIXME remove the hardcoded logic for development and test
    return if Rails.env.development? || Rails.env.test?
    if AdminDataConfig.setting[:feed_authentication_user_id].blank?
      render :text => 'No user id has been supplied for feed' and return
    end

    if AdminDataConfig.setting[:feed_authentication_password].blank?
      render :text => 'No password has been supplied for feed' and return
    end

    authenticate_or_request_with_http_basic do |id, password|
      userid_check = id == AdminDataConfig.setting[:feed_authentication_user_id]
      password_check = password == AdminDataConfig.setting[:feed_authentication_password]
      userid_check && password_check
    end
  end

end
