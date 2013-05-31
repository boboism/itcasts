class VideoThumbnail < Asset
  attr_accessible :archive
  has_attached_file :archive, :styles => {:thumb => "900x640>"}
  belongs_to :assetable, :polymorphic => true
end
