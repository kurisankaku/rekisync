require "rails_helper"

describe Tag do
  describe "#validate" do
    let(:model) { build :tag }
    context "name" do
      let!(:tag) { create :tag, name: "aaa" }

      before { Timecop.freeze(Time.local(2016, 1, 1)) }

      it "is valid when its length is 64" do
        model.name = "a" * 64
        expect(model).to be_valid
      end

      it "is invalid when its length is greater than 65" do
        model.name = "a" * 65
        expect(model).to have(1).errors_on(:name)
      end

      it "is invalid when it is nil" do
        model.name = nil
        expect(model).to have(1).errors_on(:name)
      end

      it "is invalid when it is blank" do
        model.name = ""
        expect(model).to have(1).errors_on(:name)
      end

      it "is invalid when it is not unique" do
        model.name = tag.name
        expect(model).to have(1).errors_on(:name)
      end
    end
  end
end
