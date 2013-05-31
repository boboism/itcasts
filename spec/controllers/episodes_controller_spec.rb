require 'spec_helper'

describe EpisodesController do

  let(:user)             { FactoryGirl.create(:user) }
  let(:valid_attributes) { { 
      :name => "Episode 1",
      :description => "Description",
      :notes => "notes",
      :published => false,
      :created_by_id => user.id,
      :updated_by_id => user.id
    } }

  let(:invalid_attributes) { 
    valid_attributes.merge(:name => "")
  } 

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EpisodesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all episodes as @episodes" do
      episode = Episode.create! valid_attributes
      get :index, {}, valid_session
      assigns(:episodes).should eq([episode])
    end
  end

  describe "GET show" do
    it "assigns the requested episode as @episode" do
      episode = Episode.create! valid_attributes
      get :show, {:id => episode.to_param}, valid_session
      assigns(:episode).should eq(episode)
    end
  end

  describe "GET new" do
    it "assigns a new episode as @episode" do
      get :new, {}, valid_session
      assigns(:episode).should be_a_new(Episode)
    end
  end

  describe "GET edit" do
    it "assigns the requested episode as @episode" do
      episode = Episode.create! valid_attributes
      get :edit, {:id => episode.to_param}, valid_session
      assigns(:episode).should eq(episode)
    end
  end

  describe "POST create" do

    before do
      controller.stub(:current_user).and_return(user)
      user.stub(:admin?).and_return(true)
    end

    describe "with valid params" do
      it "creates a new Episode" do
        expect {
          post :create, {:episode => valid_attributes}, valid_session
        }.to change(Episode, :count).by(1)
      end

      it "assigns a newly created episode as @episode" do
        post :create, {:episode => valid_attributes}, valid_session
        assigns(:episode).should be_a(Episode)
        assigns(:episode).should be_persisted
      end

      it "redirects to the created episode" do
        post :create, {:episode => valid_attributes}, valid_session
        response.should redirect_to(Episode.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved episode as @episode" do
        # Trigger the behavior that occurs when invalid params are submitted
        Episode.new(invalid_attributes).stub(:save).and_return(false)
        post :create, {:episode => { "name" => "" }}, valid_session
        assigns(:episode).should be_a_new(Episode)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Episode.new(invalid_attributes).stub(:save).and_return(false)
        post :create, {:episode => { "name" => "" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    before do
      controller.stub(:current_user).and_return(user)
      user.stub(:admin?).and_return(true)
    end

    describe "with valid params" do
      it "updates the requested episode" do
        episode = Episode.create! valid_attributes
        put :update, {:id => episode.to_param, :episode => { "name" => "MyString" }}, valid_session
        response.should redirect_to episode_path(episode)
        flash[:notice].should == "Episode was successfully updated."
      end

      it "assigns the requested episode as @episode" do
        episode = Episode.create! valid_attributes
        put :update, {:id => episode.to_param, :episode => valid_attributes}, valid_session
        assigns(:episode).should eq(episode)
      end

      it "redirects to the episode" do
        episode = Episode.create! valid_attributes
        put :update, {:id => episode.to_param, :episode => valid_attributes}, valid_session
        response.should redirect_to(episode)
      end
    end

    describe "with invalid params" do
      it "assigns the episode as @episode" do
        episode = Episode.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Episode.any_instance.stub(:save).and_return(false)
        put :update, {:id => episode.to_param, :episode => { "name" => "invalid value" }}, valid_session
        assigns(:episode).should eq(episode)
      end

      it "re-renders the 'edit' template" do
        episode = Episode.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Episode.any_instance.stub(:save).and_return(false)
        put :update, {:id => episode.to_param, :episode => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested episode" do
      episode = Episode.create! valid_attributes
      expect {
        delete :destroy, {:id => episode.to_param}, valid_session
      }.to change(Episode, :count).by(-1)
    end

    it "redirects to the episodes list" do
      episode = Episode.create! valid_attributes
      delete :destroy, {:id => episode.to_param}, valid_session
      response.should redirect_to(episodes_url)
    end
  end

end
