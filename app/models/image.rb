class Image < ActiveRecord::Base
  belongs_to :product

  has_attached_file :picture, styles: { medium: '360x360>', thumb: '190x190>' }
  validates_attachment :picture, presence: true, size: { less_than: 1.megabytes },
    content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png'] }
end
