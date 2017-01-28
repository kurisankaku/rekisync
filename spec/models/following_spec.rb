require "rails_helper"

describe Following do
  include ErrorExamples

  it_behaves_like "logical deletion", :following

  describe "#validate" do
    let(:model) { build :following }

    context "owner" do
      let!(:following) { create :following }
      let!(:following_deleted) { create :following, deleted_at: Time.now }

      it "is invalid when it is nil" do
        model.owner = nil
        expect(model).to have(1).errors_on(:owner)
      end

      it "is valid when owner exists but user not exists" do
        model.owner = following.owner
        expect(model).to be_valid
      end

      it "is valid when user exists but owner not exists" do
        model.user = following.user
        expect(model).to be_valid
      end

      it "is invalid when combination of owner and user already exists" do
        model.owner = following.owner
        model.user = following.user
        expect(model).to have(1).errors_on(:owner)
      end

      it "is invalid when deleted combination of owner and user already exists" do
        model.owner = following_deleted.owner
        model.user = following_deleted.user
        expect(model).to have(1).errors_on(:owner)
      end
    end

    context "user" do
      it "is invalid when it is nil" do
        model.user = nil
        expect(model).to have(1).errors_on(:user)
      end

      it "is invalid when it is same as owner" do
        model.user = model.owner
        expect(model).to have(1).errors_on(:user)
      end
    end
  end
end
