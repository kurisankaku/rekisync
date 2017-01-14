require "rails_helper"

describe Profile do
  describe "#validate" do
    let(:model) { build :profile }
    context "name" do
      it "is valid when its length is 1" do
        model.name = "a"
        expect(model).to be_valid
      end

      it "is valid when its length is 128" do
        model.name = "a" * 128
        expect(model).to be_valid
      end

      it "is invalid when its length is 129" do
        model.name = "a" * 129
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
    end

    context "user" do
      it "is invalid when it is nil" do
        model.user = nil
        expect(model).to have(1).errors_on(:user)
      end
    end

    context "img_dir_prefix" do
      it "is valid when its length is 4" do
        model.img_dir_prefix = SecureRandom.hex(2)
        expect(model).to be_valid
      end

      it "is invalid when its length is 3" do
        model.img_dir_prefix = "1ab"
        expect(model).to have(1).errors_on(:img_dir_prefix)
      end

      it "is invalid when its length is 5" do
        model.img_dir_prefix = "12abc"
        expect(model).to have(1).errors_on(:img_dir_prefix)
      end

      context "when updates img_dir_prefix to nil" do
        it "is invalid" do
          model.img_dir_prefix = SecureRandom.hex(2)
          model.save!

          begin
            model.img_dir_prefix = nil
            model.save!
            fail
          rescue ActiveRecord::RecordInvalid => e
            expect(e.record.errors.details[:img_dir_prefix]).to include(error: :blank)
          end
        end
      end
    end

    {
      state_city: 255,
      street: 255,
      website: 1024,
      twitter: 1024,
      facebook: 1024,
      google_plus: 1024
    }.each do |key, value|
      context key.to_s do
        it "is valid when its length is 1" do
          model[key] = "a"
          expect(model).to be_valid
        end

        it "is valid when its length is #{value}" do
          model[key] = "a" * value
          expect(model).to be_valid
        end

        it "is invalid when its length is #{value + 1}" do
          model[key] = "a" * (value + 1)
          expect(model).to have(1).errors_on(key)
        end
      end
    end
  end

  describe "#generate_img_dir_prefix" do
    let!(:model) { build :profile }
    context "when creates model which img_dir_prefix is blank" do
      it "generates img_dir_prefix" do
        model.img_dir_prefix = nil
        model.save!
        expect(model.img_dir_prefix).to be_present
      end
    end

    context "when creates model which img_dir_prefix is not blank" do
      it "not generates img_dir_prefix" do
        img_dir_prefix = model.img_dir_prefix
        model.save!
        expect(model.img_dir_prefix).to eq img_dir_prefix
      end
    end
  end
end
