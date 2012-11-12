require "course"

class Course
  Javascript = Course.new("javascript") do
    lesson "javascript_basics"
    lesson "functions_and_closures"
    lesson "dom"
    lesson "jquery"
    lesson "ajax"
    lesson "object_oriented_javascript"
    lesson "node"
  end
end