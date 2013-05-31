require 'streamio-ffmpeg'

class Episode < ActiveRecord::Base

  TRANSCODE_OPTIONS = "-r 30 -vcodec libx264 -flags +loop -crf 24 -bt 256k -refs 1 -coder 0 -me_range 16 -subq 5 -partitions +parti4x4+parti8x8+partp8x8 -g 250 -keyint_min 25 -level 30 -qmin 10 -qmax 51 -trellis 2 -sc_threshold 40 -i_qfactor 0.71 -acodec libfaac -ab 128k -ar 48000 -ac 2 -movflags faststart"

  belongs_to :created_by,   :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updated_by,   :class_name => "User", :foreign_key => "updated_by_id"
  belongs_to :published_by, :class_name => "User", :foreign_key => "published_by_id"

  has_one :episode_image,   :as => :assetable, :class_name => "EpisodeImage", :dependent => :destroy
  has_one :video,           :as => :assetable, :class_name => "Video",        :dependent => :destroy

  acts_as_taggable

  accepts_nested_attributes_for :episode_image, :video, :allow_destroy => true

  attr_accessible :description, 
                  :name, 
                  :notes, 
                  :published, 
                  :published_at, 
                  :published_by_id,
                  :transcode_required, 
                  :created_by_id, 
                  :updated_by_id,
                  :episode_image_attributes, 
                  :video_attributes,
                  :tag_names,
                  :transcoded,
                  :transcoded_at,
                  :transcoded_by_id

  validates :name,            :presence => true,
                              :length   => { :within => 4..20 }
#  validates :description,     :presence => true, 
#                              :length   => { :within => 10..200 }
  validates :published_at,    :presence => true, 
                              :if       => :published
  validates :published_by_id, :presence => true, 
                              :if       => :published
  validates :created_by_id,   :presence => true
  validates :updated_by_id,   :presence => true

  default_scope {includes(:episode_image, :video, :tags).order("episodes.id DESC")}
  scope :unpublished,        lambda{ where(:published => false) }
  scope :published,          lambda{ where(:published => true) }
  scope :untranscoded,       lambda{ where(:transcoded => false) }
  scope :transcoded,         lambda{ where(:transcoded => true) }
  scope :search,             lambda{|search|
    search ||= {}
    episodes = scoped
    if search[:text]
      tagged_episode_ids = with_tags(search[:text]).select("episodes.id")
      named_episode_ids  = where("episodes.name like ?", "%#{search[:text]}%").select("episodes.id")
      episodes = episodes.where(:id => [tagged_episode_ids, named_episode_ids].flatten)
    end 
    episodes
  }
  scope :with_tags, lambda{|tag|
    tag = tag.split(/\s+/)  if tag.is_a? String
    tag = Array(tag)
    episodes = scoped
    episodes = episodes.tagged_with(tag, :any => true) unless tag.empty?
    episodes
  }

  def self.has_transcoding_episodes?
    transcoding.count > 0
  end

  def title; I18n.t("activerecord.attributes.episode.title", id: ('%03d' % id), name: name); end
  
  def tag_names
    tag_list.join(" ")
  end

  def tag_names=(value)
    self.tag_list = value.split(/\s+/).reject(&:nil?).join(", ")
  end

  def published_by!(user)
    raise "Episode #{name} already published" if published?
    
    self.transaction do
      update_attributes(:published => true, :published_at => DateTime.now, :published_by_id => user.id, :updated_by_id => user.id)
    end
    true
  end

  def update!(attrs={})
    self.transaction do
      update_attributes(attrs)
    end
  end

  def transcoded_by!(user)
    return unless published? && !transcoded?
    transcoded_episode_path = "/tmp/episode_#{'%03d' % id}.mp4"
    File.delete(transcoded_episode_path) if File.exists?(transcoded_episode_path)
    movie = FFMPEG::Movie.new(video.archive.path) 
    if movie.transcode(transcoded_episode_path, TRANSCODE_OPTIONS) && File.exists?(transcoded_episode_path)
      ActiveRecord::Base.transaction do 
        update_attributes(:video_attributes => { :archive => File.open(transcoded_episode_path) }, 
                          :transcoded       => true,
                          :transcoded_by_id => user.id,
                          :transcoded_at    => DateTime.now,
                          :updated_by_id    => user.id
                         )
      end
      File.delete(transcoded_episode_path) 
    end
    self.transcoded?
  end
end
