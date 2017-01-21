module Concerns
  module UploadDirectory
    extend ActiveSupport::Concern

    # Store image root directory.
    def root_dir
      Rails.env == "development" ? "uploads/" : ""
    end
  end
end
