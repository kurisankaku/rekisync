# Owner controller.
class OwnerController < ApplicationController
  # Show owner page.
  def show
    begin
      @user = UserService.new.find_by_name(params[:name])
    rescue BadRequestError => e
      logger.error build_log(e, e.status_code).to_json
      raise NotFoundPageError
    end
  end
end
