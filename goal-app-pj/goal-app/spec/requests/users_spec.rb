require 'rails_helper'

RSpec.describe "Users", type: :request do
  subject (:jasmine) { User.create!(usernmae: "jasmine", password: "password")}

    describe "Get users/new" do
      it "renders the signup page" do
        get new_user_url
          expect(response.body).to include("Sign Up")
          expect(response.body).not_to include("Sign In")
          expect(response.body).not_to include("All Users")
          expect(response.body).not_to include("Goals for")
      end
    end

    describe "Post users/create" do
      context "with blank username" do
        it "properly stores and renders 'username cannot be blank' and redirects to the signup page" do
          post users_url, params: {user: {username: "", password: "password"}}
          expect(response.body).to include("Sign Up")
          expect(response.body).not_to include("Sign In")
          expect(response.body).not_to include("All Users")
          expect(response.body).not_to include("Goals for")
          expect(flash.now[:errors]).to eq(['username cannot be blank'])
        end
      end
    end

end
