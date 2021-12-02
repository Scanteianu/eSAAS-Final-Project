require "rails_helper"

describe ApplicationController, type: :controller do
  describe "verify_user" do
    context "user email is nil" do
      it "return false" do
        value=@controller.verify_user(nil)
        expect(value).to eq(false)
      end
    end

    context "user email is not nil" do
      context "user email includes columbia.edu or barnard.edu" do
        it "returns true" do
          value1=@controller.verify_user("test1@columbia.edu")
          expect(value1).to eq(true)
          value2=@controller.verify_user("test1@barnard.edu")
          expect(value2).to eq(true)
        end
      end
      context "user email does not include columbia.edu or barnard.edu" do
        it "returns false" do
          value=@controller.verify_user("test1@gmail.com")
          expect(value).to eq(false)
        end
      end
    end
  end
    
  describe "getFromSessionObject" do
    context "if there is an injected session object" do
      it "returns injected session param" do
        test_username = "test@columbia.edu"
        $injectedSession = { :username => test_username }
        injected_session_username = @controller.getFromSessionObject(:username)
        expect(injected_session_username).to eq(test_username)
        $injectedSession = nil # Set back to nil so other tests aren't affected by the global variable
      end
    end

    context "if there is no injected session object" do
      it "returns the session param" do
        test_username = "test@columbia.edu"
        session[:username] = test_username
        session_username = @controller.getFromSessionObject(:username)
        expect(session_username).to eq(test_username)
      end
    end
  end
end
