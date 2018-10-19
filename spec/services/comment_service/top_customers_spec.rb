RSpec.describe CommentServices::TopCustomers do
  subject { described_class.call }

  describe "oreded list test" do
    context "when show top customers ordered list" do
      let(:user_1) { create(:user, :with_comment, email: "jordan01@gmail.com") }
      let(:user_2) { create(:user, :with_comment, email: "john22@gmail.com") }
      let(:user_3) { create(:user, :with_comment, email: "pablo44@gmail.com") }

      before do
        create_list :comment, 24, user: user_1
        create_list :comment, 15, user: user_2
        create_list :comment, 10, user: user_3

        10.times { |i| create(:user, :with_comment, email: "#{i}test@gmail.com") }
        3.times { |i| create(:user, :with_old_comment, email: "#{20 + i}test@gmail.com") }
      end

      it "returns list with correctly oredered data" do
        expect(subject[0]).to eq("email" => user_1.email, "coments_counted" => 28)
        expect(subject[1]).to eq("email" => user_2.email, "coments_counted" => 19)
        expect(subject[2]).to eq("email" => user_3.email, "coments_counted" => 14)
        expect(subject[3]).to include("coments_counted" => 4)
      end

      it "returns max 10 record" do
        expect(subject.size).to eq(10)
      end
    end
  end

  describe "test limit" do
    context "when 15 users have comments created in this week" do
      before do
        15.times { |i| create(:user, :with_comment, email: "#{i}test@gmail.com") }
      end

      it "returns 10 records" do
        expect(subject.size).to eq(10)
      end
    end

    context "when 10 users have comments older then week" do
      before do
        10.times { |i| create(:user, :with_old_comment, email: "#{i}test@gmail.com") }
      end

      it "returns 0 records" do
        expect(subject.size).to eq(0)
      end
    end

    context "when there is no users with coments" do
      it "returns 0 records" do
        expect(subject.size).to eq(0)
      end
    end
  end
end
