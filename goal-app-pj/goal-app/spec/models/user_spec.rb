require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.create!(username: "test_user", password: "password") } 

  it { should validate_presence_of(:username)}
  it { should validate_presence_of(:session_token)}
  it { should validate_presence_of(:password_digest}
  it { should validate_uniqueness_of(:username)}
  it { should validate_uniqueness_of(:session_token)}
  it { should validate_length_of(:password).is_at_least(6)}
  it { should have_many(:goals)}

  describe "Password Encryption" do # Spec name
    it "does not save passwords to the database" do # describes what the code should do
      User.create!(username: "ian", password: "verger") # creates and saves user into db
      ian = User.find_by(username: 'ian') # sets ian to created user
      
      expect(ian.password).not_to be("verger") # makes sure there is no password saved / no password column
    end

    context "Saves the password properly" do

      it "Properly encrypts the password with BCrypt" do
        expect(BCrypt::Password).to recieve(:create)
        User.new(username: "wilson", password: "password")
      end

      it "Creates an instance varaible for password" do
        user = User.new(username: "wilson", password: "password")
        expect(user.password).to eq('password')
      end

    end
  end
end
