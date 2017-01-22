# AccessScope
class AccessScope < ApplicationRecord
  include CodeMaster

  acts_as_code_master :code, %w(
    private
    public
    follower
    follower-following
  )
end
