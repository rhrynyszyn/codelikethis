require 'erector'
require 'thing'

class Link < Thing
  attr_reader :name, :href, :description, :icon

  def ==(other)
    other.is_a?(Link) and
        other.name == name and
        other.href == href and
        other.description == description
  end

  def name
    @name || href
  end

  def display_name
    @display_name || name
  end

  def view
    View.new(target: self)
  end

  class View < Erector::Widget
    needs :target
    attr_reader :target

    # proxy readers to the target (model) object
    [
        :display_name, :href, :description,
        :optional, # hack: this is on Project
    ].each do |method|
      define_method method do
        @target.send method
      end
    end

    def content
      span(class: 'link') {
        if target.respond_to? :icon and target.icon
          span(class: 'icon') {
            img src: target.icon, alt: 'icon', title: 'icon'
          }
        end
        if href
          a display_name, href: href
        else
          span display_name
        end

        if description
          text " - "
          span description, class: "description"
        end

        # hack: for Project
        span " [optional]" if target.respond_to? :optional and target.optional
      }
    end
  end
end

class Thing
  contains :links  # any thing can have links
end
