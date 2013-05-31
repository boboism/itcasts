class Asset < ActiveRecord::Base
  IMAGE_CONTENT_TYPES = [
    "image/bmp",
    "image/cis-cod",
    "image/gif",
    "image/ief",
    "image/jpeg",
    "image/jpeg",
    "image/jpeg",
    "image/pipeg",
    "image/svg+xml",
    "image/tiff",
    "image/tiff",
    "image/x-cmu-raster",
    "image/x-cmx",
    "image/x-icon",
    "image/x-portable-anymap",
    "image/x-portable-bitmap",
    "image/x-portable-graymap",
    "image/x-portable-pixmap",
    "image/x-rgb",
    "image/x-xbitmap",
    "image/x-xpixmap",
    "image/x-xwindowdump"]

  VIDEO_CONTENT_TYPES = [
    "video/mp4",
    "video/mov"
  ]
end
