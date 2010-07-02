require 'action_controller'

class Helper
  include ActionView::Helpers

  def display_photo(profile, size, html = {}, options = {}, link = true)
    return "wrench.png" unless profile  # this should not happen

    show_default_image = !(options[:show_default] == false)
    html.reverse_merge!(:class => 'thumbnail', :size => size, :title => "Link to #{profile.name}")

    if profile.has_valid_photo?
      image = url_for_file_column("user", "photo", size)
    elsif show_default_image
      size = '190x114' if profile.user && profile.user.rep?
      image = "user#{size}.jpg"
      html = {}
    else
      return 'NO DEFAULT'
    end

    result = image_tag(image, html) 
    return link ? link_to(result, profile_path(profile)) : result
  end

  self.class_eval do
    {
      :small => '32x32',
      :medium => '48x48',
      :large => '64x64',
      :huge => '200x200'
    }.each_pair do |name, size|
      define_method "display_#{name}_photo" do |profile, options, link|
        size = '190x114' if profile.user && profile.user.rep?
        display_photo(profile, size, {}, options, link)
      end
    end
  end
end
