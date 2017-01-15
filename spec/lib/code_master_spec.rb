require "rails_helper"
require "code_master"

class Master
  include CodeMaster

  acts_as_code_master :code, %w(ja en ch)

  def code
    "en"
  end
end

describe CodeMaster do
  describe ".acts_as_code_master" do
    describe ".master_codes" do
      it { expect(Master.master_codes).to eq ["ja", "en", "ch"] }
    end

    describe "#master_codes" do
      it { expect(Master.new.master_codes).to eq ["ja", "en", "ch"] }
    end

    describe "#master_code?" do
      it { expect(Master.new.master_code?("ja")).to be false }
      it { expect(Master.new.master_code?("en")).to be true }
      it { expect(Master.new.master_code?("ch")).to be false }
    end

    describe "#xxx?" do
      it { expect(Master.new.ja?).to be false }
      it { expect(Master.new.en?).to be true }
      it { expect(Master.new.ch?).to be false }
    end
  end
end
