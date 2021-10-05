# frozen_string_literal: true

module ProjectHelper
  def event_select_options(event_names, url_params)
    event_names.map do |e|
      "<option data-url='#{build_event_url(e, url_params)}' data-name='#{e.parameterize}'>#{e}</option>"
    end
  end

  def agg_select_options(url_params)
    Event.aggregations.map do |k, v|
      "<option data-url='#{build_agg_url(k, url_params)}' data-name='#{k}'>#{v.capitalize}</option>"
    end
  end

  def property_select_options(props, url_params)
    props.unshift("All")
    props.map do |p|
      "<option data-url='#{build_property_url(p, url_params)}' data-name='#{p.parameterize}'>#{p}</option>"
    end
  end

  def build_event_url(event_name, url_params)
    project_path(
      url_params[:slug],
      event: event_name.parameterize,
      test: url_params[:test],
      agg: url_params[:agg]
    )
  end

  def build_agg_url(agg, url_params)
    project_path(
      url_params[:slug],
      event: url_params[:event],
      test: url_params[:test],
      agg: agg,
      prop: url_params[:prop]
    )
  end

  def build_property_url(prop, url_params)
    project_path(
      url_params[:slug],
      event: url_params[:event],
      test: url_params[:test],
      agg: url_params[:agg],
      prop: prop
    )
  end
end
