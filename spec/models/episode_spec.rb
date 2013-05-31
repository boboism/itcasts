require 'spec_helper'

describe Episode do

  let(:user)         { FactoryGirl.create(:user) }
  let(:valid_params) { {
      :name => "Episode 1",
      :description => "Description",
      :notes => "notes",
      :published => false,
      :created_by_id => user.id,
      :updated_by_id => user.id
    } }
  let(:episode)     { Episode.create(valid_params) }

  it "should create a new instance given a valid attribute" do
    Episode.create!(valid_params)
  end

  it "should require a name" do
    no_name_episode = Episode.new(valid_params.merge(:name => ""))
    no_name_episode.should_not be_valid
  end

  it "should have a name which length between 4 and 20" do
    valid_name_episode = Episode.new(valid_params)
    valid_name_episode.name.length.between?(4,20).should be_true
  end

  it "should require a publish date while publishing" do
    no_published_at_episode = Episode.new(valid_params.merge(:published => true))
    no_published_at_episode.should_not be_valid
  end

  it "should require a publisher while publishing" do
    no_publisher_episode = Episode.new(valid_params.merge(:published => true))
    no_publisher_episode.should_not be_valid
  end

  it "should require a creator while creating" do
    no_publisher_episode = Episode.new(valid_params.merge(:created_by_id => nil))
    no_publisher_episode.should_not be_valid
  end

  it "should require a updater while creating" do
    no_publisher_episode = Episode.new(valid_params.merge(:updated_by_id => nil))
    no_publisher_episode.should_not be_valid
  end

  describe "#published_by!" do

    context "when episode is NOT published" do

      it "should be published once" do
        episode.published_by!(user)
        episode.published.should be_true
      end

      it "should update published status from false to true" do
        expect {
          episode.published_by!(user)
        }.to change {episode.published}.from(false).to(true)
      end

      it "should have a publisher" do
        expect {
          episode.published_by!(user)
        }.to change {episode.published_by_id}.from(nil).to(user.id)
      end

    end

    context "when episode is published" do

      it "should NOT be published twice" do
        expect {
          2.times{ episode.published_by!(user) }
        }.to raise_error
      end

    end 
  end

end
