module ProductsHelper
  def tags_tag(product)
    content_tag :p do
      content_tag(:span, ' ', class: 'icon-tags') + build_tags(product.tags)
    end
  end

  def inventory_tag(product)
    content_tag(:span, ' ', class: 'icon-barcode') + inventory_info(product)
  end

  def status_tag(product)
    content_tag(:span, t('.state') + ' ') + state_info(product)
  end

  def picture_tag(product, &block)
    image = product.images.try(:first)

    inline = ''
    inline = capture(&block) if block_given?
    if image
      content_tag :div, class: 'image' do
        image_tag(image.picture.url(:medium)) + inline
      end
    else
      content_tag :div, class: 'no-image' do
        content_tag(:span, ' ', class: 'icon-camera') + inline
      end
    end
  end

  def pictures_tag(product)
    actual_images = product.images.select{ |image| not image.new_record? }

    image_content = ''
    unless actual_images.empty?
      content_tag :div, class: 'twelve pictures' do
        actual_images.each do |image|
          image_content += content_tag :div, class: 'two' do
            image_tag image.picture.url(:thumb)
          end
        end

        image_content.html_safe
      end
    end
  end

protected
  def state_info(product)
    icon = 'icon-ok-sign green'
    icon = 'icon-minus-sign red' unless product.active

    content_tag(:span, ' ', class: icon)
  end

  def inventory_info(product)
    if product.infinite
      '&infin;'.html_safe
    else
      number_with_delimiter(product.inventory || 0)
    end
  end

  def build_tags(tags)
    html_tags = ''

    (tags || '').split(',').each do |tag|
      html_tags += content_tag :span, tag, class: 'tag'
    end

    html_tags.html_safe
  end
end
