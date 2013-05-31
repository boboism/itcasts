class EpisodeImage < Asset
  attr_accessible :archive
  belongs_to :assetable, :polymorphic => true

  has_attached_file :archive, :styles          => { :thumb => "210x118>" }, 
                              :convert_options => { :thumb => "-quality 75 -strip" },
                              :path            => ":rails_root/public/system/:class/:id/:hash.:extension",
                              :url             => "/system/:class/:id/:hash.:extension",
                              :hash_secret     => "itcasts_episode_image"


  validates_attachment :archive, :presence     => true,
                                 :content_type => { :content_type => Asset::IMAGE_CONTENT_TYPES }

end
