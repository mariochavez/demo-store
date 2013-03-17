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
