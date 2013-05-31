class EpisodesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource

  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.accessible_by(current_ability).search(params[:search]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @episodes }
    end
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
    @episode = Episode.accessible_by(current_ability).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @episode }
    end
  end

  # GET /episodes/new
  # GET /episodes/new.json
  def new
    @episode = Episode.new do |episode|
      episode.episode_image = EpisodeImage.new
      episode.video         = Video.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @episode }
    end
  end

  # GET /episodes/1/edit
  def edit
    @episode = Episode.find(params[:id])
  end

  # POST /episodes
  # POST /episodes.json
  def create
    @episode = Episode.unpublished.untranscoded.new(params[:episode].merge(:created_by_id => current_user.id, :updated_by_id => current_user.id))

    respond_to do |format|
      if @episode.save
        format.html { redirect_to @episode, notice: 'Episode was successfully created.' }
        format.json { render json: @episode, status: :created, location: @episode }
      else
        format.html { render action: "new" }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /episodes/1
  # PUT /episodes/1.json
  def update
    @episode = Episode.find(params[:id])

    respond_to do |format|
      if @episode.update!(params[:episode].merge(:updated_by_id => current_user.id))
        format.html { redirect_to @episode, notice: 'Episode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.json
  def destroy
    @episode = Episode.find(params[:id])
    @episode.destroy

    respond_to do |format|
      format.html { redirect_to episodes_url }
      format.json { head :no_content }
    end
  end

  # PUT /episodes/1/publish
  # PUT /episodes/1/publish.json
  def publish
    @episode = Episode.find(params[:id])
    respond_to do |format|
      if @episode.published_by!(current_user)
          @episode.delay_for(1.minutes).transcoded_by!(current_user)
          format.html { redirect_to @episode, notice: I18n.t('episodes.publish_success') }
          format.json { head :no_content }
      else
          format.html { redirect_to @episode, flash: { error: @episode.errors } }
          format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

end
