# frozen_string_literal: true

module ProjectHelper
  def event_select_options(event_names, slug, test, agg)
    event_names.map do |e|
      "<option data-url='#{build_event_url(e, slug, test, agg)}' data-name='#{e.parameterize}'>#{e}</option>"
    end
  end

  def agg_select_options(event_name, slug, test)
    Event.aggregations.map do |k, v|
      "<option data-url='#{build_agg_url(event_name, slug, test, k)}' data-name='#{k}'>#{v.capitalize}</option>"
    end
  end

  def build_event_url(event_name, slug, test, agg)
    project_path(slug, event: event_name.parameterize, test: test, agg: agg)
  end

  def build_agg_url(event_name, slug, test, agg)
    project_path(slug, event: event_name, test: test, agg: agg)
  end
end
