# Home controller.
class HomeController < ApplicationController
  def index
    logger.unknown("不明なエラー")
    logger.fatal("致命的なエラー")
    logger.error("エラー")
    logger.warn("警告")
    logger.info("通知")
    logger.debug("デバッグ情報")
  end
end
