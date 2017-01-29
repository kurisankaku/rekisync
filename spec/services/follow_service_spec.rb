require "rails_helper"

describe FollowService do
  include ErrorExamples

  describe "#follow_user" do
    subject { described_class.new.follow_user(owner, followed_user) }

    context "follow the user have never been followed" do
      let!(:owner) { create :user }
      let!(:followed_user) { create :user }

      it "creates new following" do
        expect { subject }.to change(Following, :count).by(1)
      end

      it "return new following" do
        following = subject
        expect(following.owner).to eq owner
        expect(following.user).to eq followed_user
      end
    end

    context "follow the user you followed before" do
      let!(:owner) { create :user }
      let!(:followed_user) { create :user }
      let!(:deleted_following) { create :following, owner: owner, user: followed_user, deleted_at: Time.now }

      it "updates exist following" do
        expect { subject }.to change(Following, :count).by(1)
      end

      it "restore deleted_following" do
        subject
        expect(deleted_following.reload.deleted_at).to be_nil
      end
    end
  end

  describe "#unfollow_user" do
    subject { described_class.new.unfollow_user(owner, unfollowed_user) }

    context "unfollow the user" do
      let!(:owner) { create :user }
      let!(:unfollowed_user) { create :user }
      let!(:following) { create :following, owner: owner, user: unfollowed_user }
      it "deletes the following" do
        expect { subject }.to change(Following, :count).by(-1)
      end
    end

    context "unfollow the user who have not follow" do
      let!(:owner) { create :user }
      let!(:unfollowed_user) { create :user }
      it_behaves_like "bad request error", :not_followed_user, :user
    end
  end
end
