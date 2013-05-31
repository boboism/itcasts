class Video < Asset
  attr_accessible :archive
  belongs_to :assetable, :polymorphic => true
  has_attached_file :archive, :path        => ":rails_root/public/system/:class/:id/:hash.:extension",
                              :url         => "/system/:class/:id/:hash.:extension",
                              :hash_secret => "itcasts_video"

  validates_attachment :archive, :presence     => true
                                 #:content_type => { :content_type => Asset::VIDEO_CONTENT_TYPES }
end
