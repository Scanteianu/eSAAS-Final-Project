require "rails_helper"

describe ApplicationController, type: :controller do
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
