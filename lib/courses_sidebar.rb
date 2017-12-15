require 'erector'

class CoursesSidebar < Erector::Widget

  needs :courses, :current

  def current_course
    if @current.is_a?(Course)
      @current
    elsif @current.is_a?(Lesson)
      @current.course
    end
  end

  def current_lesson
    @current if @current.is_a?(Lesson)
  end

  def content
    div(class: 'row justify-content-between') {
      div(class: 'col-8') {
        h3 "Courses"
      }
      div(class: 'col-4') {
        # hamburger button for courses
        button(:class => 'courses-toggler btn border-0 collapsed',
               :type => 'button',

               'data-toggle' => 'collapse',
               'data-target' => "##{html_id}",

               'aria-expanded' => 'false',
               'aria-label' => 'Toggle navigation'
        ) {
          span :class => 'svg-icon'
        }
      }
    }

    div(id: html_id, class: 'collapse') {
      div(id: "#{html_id}-courses") {
        @courses.each do |course|
          course_row(course)
        end
      }
    }
  end

  def html_id
    "sidebar-courses"
  end

  def course_row(course)
    classes = ['list-group-item', ('show' if current_course == course)]

    div(class: classes) {
      lessons_id = "sidebar-#{course.name}-lessons"

      a course.display_name,
        href: "##{lessons_id}",
        'data-toggle': 'collapse',
        'data-target': "##{lessons_id}",
        'data-parent': "##{html_id}-courses"

      # button "lessons",
      #        class: 'btn',
      #        type: 'button',
      #        'data-toggle': 'collapse',
      #        'data-target': "##{lessons_id}"
      # 'aria-expanded': false
      # 'aria-controls': '???'

      # labs_id = "sidebar-#{course.name}-labs"
      # button "labs",
      #        class: 'btn btn-primary',
      #        type: 'button',
      #        'data-toggle': 'collapse',
      #        'data-target': labs_id,
      #        'aria-expanded': false
      #        # 'aria-controls': '???'

      div(class: ['collapse', ('show' if course.lessons.include?(@current))],
          id: lessons_id) {
        div(class: 'list-group') {
          course.current = @current
          widget course, {}, :content_method_name => :list_lessons
        }
      }

      # ul(class: 'list-group', id: labs_id) {
      #   widget course, {}, :content_method_name => :list_labs
      # }
    }

    # script raw(<<-JS)
    # // when a collapsible is shown
    # $('#sidebar .collapse').on('show.bs.collapse', function() {
    #   console.log("hello!");
    #   // then hide all currently shown
    #   $('#sidebar .collapse.show').collapse('hide');
    # });
    # JS
  end

end
