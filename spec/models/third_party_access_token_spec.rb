require 'rails_helper'

describe ThirdPartyAccessToken do
  describe "#validate" do
    let(:model) { build :third_party_access_token }

    context "uid" do
      it "is valid when it is presented" do
        model.uid = SecureRandom.hex(64)
        expect(model).to be_valid
      end

      it "is invalid when it is nil" do
        model.uid = nil
        expect(model).to have(1).errors_on(:uid)
      end

      it "is invalid when it is blank" do
        model.uid = ""
        expect(model).to have(1).errors_on(:uid)
      end
    end

    context "provider" do
      it "is valid when it is presented" do
        model.provider = Faker::Lorem.characters(32)
        expect(model).to be_valid
      end

      it "is invalid when it is nil" do
        model.provider = nil
        expect(model).to have(1).errors_on(:provider)
      end

      it "is invalid when it is blank" do
        model.provider = ""
        expect(model).to have(1).errors_on(:provider)
      end

      it "is valid when its length 32" do
        model.provider = "a" * 32
        expect(model).to be_valid
      end

      it "is invalid when its length greater than 33" do
        model.provider = "a" * 33
        expect(model).to have(1).errors_on(:provider)
      end
    end

    context "token" do
      it "is valid when it is presented" do
        model.token = SecureRandom.hex(64)
        expect(model).to be_valid
      end

      it "is invalid when it is nil" do
        model.token = nil
        expect(model).to have(1).errors_on(:token)
      end

      it "is invalid when it is blank" do
        model.token = ""
        expect(model).to have(1).errors_on(:token)
      end
    end

    context "user" do
      it "is valid when it is presented" do
        model.user = build(:user)
        expect(model).to be_valid
      end

      it "is invalid when it is nil" do
        model.user = nil
        expect(model).to have(1).errors_on(:user)
      end
    end
  end
end
