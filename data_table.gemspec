Gem::Specification.new do |s|
  s.name     = "data_table"
  s.version  = "0.1.0"
  s.date     = "2008-08-04"
  s.summary  = "Sorting, filtering, and pagination.  Together at last."
  s.email    = "jim@jimvanfleet.com"
  s.homepage = "http://github.com/bigfleet/data_table"
  s.description = "data_table allows for integration of sorting, filtering, and pagination at the model, view, and controller layers."
  s.has_rdoc = false
  s.authors  = ["Jim Van Fleet"]
  s.files    = ["init.rb",
  "lib/data_table/filter.rb",
  "lib/data_table/filter_element.rb",
  "lib/data_table/filter_selection.rb",
  "lib/data_table/filter_view_helpers.rb",
  "lib/data_table/link_renderer.rb",
  "lib/data_table/pagination_support.rb",
  "lib/data_table/sort.rb",
  "lib/data_table/sort_option.rb",
  "lib/data_table/sort_view_helpers.rb",
  "lib/data_table/view_helpers.rb",
  "lib/data_table/wrapper.rb",
  "lib/data_table.rb",
  "MIT-LICENSE",
  "Rakefile",
  "README.textile",
  "spec/data_table_spec.rb",
  "spec/filter_element_spec.rb",
  "spec/filter_selection_spec.rb",
  "spec/filter_spec.rb",
  "spec/filter_view_helpers_spec.rb",
  "spec/pagination_support_spec.rb",
  "spec/requirements_spec.rb",
  "spec/sort_option_spec.rb",
  "spec/sort_spec.rb",
  "spec/sort_view_helpers_spec.rb",
  "spec/spec.opts",
  "spec/spec_helper.rb"]
  s.add_dependency("will-paginate", ["> 2.2.0"])
end

