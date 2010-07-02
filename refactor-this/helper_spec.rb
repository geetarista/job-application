require 'factory_girl'
require 'factories'
require 'user_profile'
require 'helper'
require 'user'
require 'photo'
require 'active_support'

describe Helper do
  let(:helper) { Helper.new }

  describe "#display_photo" do
    context "Without a profile" do
      it "should return the wrench if there is no profile" do
        helper.display_photo(nil, "100x100", {}, {}, true).should == "wrench.png"
      end
    end

    context "With a profile, user and photo requesting a link" do
      before(:each) do
        @profile = Factory.build(:user_profile)
        @profile.user = Factory.build(:user)
        @profile.user.photo = Factory.build(:photo)
        @profile.stub!(:has_valid_photo?).and_return(true)
        helper.stub!(:url_for_file_column).with("user", "photo", "100x100").and_return("url_for_file_column")
        helper.stub!(:profile_path).with(@profile).and_return("profile_path")
      end

      it "should return a link" do
        helper.display_photo(@profile, "100x100", {}, {}, true).should ==
          "<a href=\"profile_path\"><img alt=\"Url_for_file_column\" class=\"thumbnail\" height=\"100\" src=\"/images/url_for_file_column\" title=\"Link to Clayton\" width=\"100\" /></a>"
      end
    end

    context "With a profile, user and photo not requesting a link" do
      before(:each) do
        @profile = Factory.build(:user_profile)
        @profile.user = Factory.build(:user)
        @profile.user.photo = Factory.build(:photo)
        @profile.stub!(:has_valid_photo?).and_return(true)
        helper.stub!(:url_for_file_column).with("user", "photo", "100x100").and_return("url_for_file_column")
        helper.stub!(:profile_path).with(@profile).and_return("profile_path")
      end

      it "should just an image" do
        helper.display_photo(@profile, "100x100", {}, {}, false).should ==
          "<img alt=\"Url_for_file_column\" class=\"thumbnail\" height=\"100\" src=\"/images/url_for_file_column\" title=\"Link to Clayton\" width=\"100\" />"
      end
    end
    
    context "Without a user, but requesting a link" do
      before(:each) do
        @profile = Factory.build(:user_profile)
        helper.stub!(:profile_path).with(@profile).and_return("profile_path")
      end

      it "return a default" do
        helper.display_photo(@profile, "100x100", {}, {}, true).should ==
          "<a href=\"profile_path\"><img alt=\"User100x100\" src=\"/images/user100x100.jpg\" /></a>"
      end
    end
    
    context "When the user doesn't have a photo" do
      before(:each) do
        @profile = Factory.build(:user_profile)
        @profile.user = Factory.build(:user)
        @profile.stub!(:has_valid_photo?).and_return(false)
        helper.stub!(:profile_path).with(@profile).and_return("profile_path")
      end

      context "With a rep user" do
        before(:each) do
          @profile.user.stub!(:rep?).and_return(true)
        end

        it "return a default link" do
          helper.display_photo(@profile, "100x100", {}, {}, true).should ==
            "<a href=\"profile_path\"><img alt=\"User190x119\" src=\"/images/user190x119.jpg\" /></a>"
        end
      end
      
      context "With a regular user" do
        before(:each) do
          @profile.user.stub!(:rep?).and_return(false)
          helper.stub!(:profile_path).with(@profile).and_return("profile_path")
        end

        it "return a default link" do
          helper.display_photo(@profile, "100x100", {}, {}, true).should ==
            "<a href=\"profile_path\"><img alt=\"User100x100\" src=\"/images/user100x100.jpg\" /></a>"
        end
      end
    end
    
    context "When the user doesn't have a photo and we don't want to display the default" do
      before(:each) do
        @profile = Factory.build(:user_profile)
        @profile.user = Factory.build(:user)
        @profile.stub!(:has_valid_photo?).and_return(false)
      end

      context "With a rep user" do
        before(:each) do
          @profile.user.stub!(:rep?).and_return(true)
        end

        it "return a default link" do
          helper.display_photo(@profile, "100x100", {}, {:show_default => false}, true).should == "NO DEFAULT"
        end
        
      end
      
      context "With a regular user" do
        before(:each) do
          @profile.user.stub!(:rep?).and_return(false)
          helper.stub!(:profile_path).with(@profile).and_return("profile_path")
        end

        it "return a default link" do
          helper.display_photo(@profile, "100x100", {}, {}, true).should ==
            "<a href=\"profile_path\"><img alt=\"User100x100\" src=\"/images/user100x100.jpg\" /></a>"
        end
      end
    end
  end
end
