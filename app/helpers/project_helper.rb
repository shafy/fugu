# frozen_string_literal: true

module ProjectHelper
  def event_select_options(event_names, slug, test, agg)
    event_names.map do |e|
      "<option data-url='#{build_event_url(e, slug, test, agg)}' data-name='#{e.parameterize}'>#{e}</option>"
    end
  end

  def build_event_url(event_name, slug, test, agg)
    project_path(slug, event: event_name.parameterize, test: test, agg: agg)
  end
end
