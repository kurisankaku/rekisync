require "rails_helper"

describe UserService do
  include ErrorExamples

  describe "#find" do
    subject { described_class.new.find(id, field) }

    context "find user by specified id" do
      let!(:field) { :id }
      let!(:user) { create :user }
      let!(:id) { user.id }

      it { expect(subject).to be_present }
    end
    context "not find user by specified id" do
      let!(:field) { :id }
      let!(:user) { create :user }
      let!(:id) { user.id + 1 }
      it_behaves_like "bad request error", :resource_not_found, :id
    end
  end
end
