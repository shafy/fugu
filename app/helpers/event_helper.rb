# frozen_string_literal: true

module EventHelper
  def event_select_options(url_params, aggregation, event_names)
    event_names.map do |e|
      selected = "selected" if e.parameterize == url_params[:event]
      "<option data-url='#{build_event_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, e)}' data-name='#{e.parameterize}' #{selected}>#{e}</option>"
    end
  end

  def agg_select_options(url_params, aggregation, possible_aggregations)
    Event::AGGREGATIONS.map do |k, v|
      disabled = "disabled" if possible_aggregations.exclude?(k)
      selected = "selected" if k == aggregation
      "<option data-url='#{build_agg_url(url_params.permit(*Event::EVENT_PARAMS), k)}' data-name='#{k}' #{disabled} #{selected}>#{v.capitalize}</option>"
    end
  end

  def property_select_options(url_params, aggregation, props)
    props.unshift("All")
    props.map do |p|
      selected = "selected" if p == url_params[:prop]
      "<option data-url='#{build_property_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, p)}' data-name='#{p.parameterize}' #{selected}>#{p}</option>"
    end
  end

  def date_select_options(url_params, aggregation)
    Event::DATE_OPTIONS.map do |k, v|
      selected = "selected" if k == url_params[:date]
      "<option data-url='#{build_date_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, k)}' data-name='#{k}' #{selected}>#{v}</option>"
    end
  end

  def build_event_url(url_params, aggregation, event_name)
    project_event_path(
      url_params[:project_slug],
      event_name.parameterize,
      url_params.except(:prop, :project_slug, :slug)
        .merge({ agg: aggregation })
    )
  end

  def build_agg_url(url_params, agg)
    project_event_path(
      url_params[:project_slug],
      url_params[:slug],
      url_params.except(:project_slug, :slug).merge({ agg: agg })
    )
  end

  def build_property_url(url_params, aggregation, prop)
    project_event_path(
      url_params[:project_slug],
      url_params[:slug],
      url_params.except(:project_slug, :slug).merge({ prop: prop }).merge({ agg: aggregation })
    )
  end

  def build_date_url(url_params, aggregation, date)
    project_event_path(
      url_params[:project_slug],
      url_params[:slug],
      url_params.except(:project_slug, :slug).merge({ date: date }).merge({ agg: aggregation })
    )
  end

  def build_test_toggle_url(url_params, aggregation, test)
    url_params = url_params.permit(*Event::EVENT_PARAMS)
    project_event_path(
      url_params[:project_slug],
      url_params[:slug],
      url_params.except(:project_slug, :slug).merge({ test: test }).merge({ agg: aggregation })
    )
  end
end
