# frozen_string_literal: true

module ProjectHelper
  def event_select_options(event_names, url_params, aggregation)
    event_names.map do |e|
      selected = "selected" if e.parameterize == url_params[:event]
      "<option data-url='#{build_event_url(e, url_params.permit(*Project::PROJECT_PARAMS), aggregation)}' data-name='#{e.parameterize}' #{selected}>#{e}</option>"
    end
  end

  def agg_select_options(aggregation, url_params, possible_aggregations)
    Event::AGGREGATIONS.map do |k, v|
      disabled = "disabled" if possible_aggregations.exclude?(k)
      selected = "selected" if k == aggregation
      "<option data-url='#{build_agg_url(k, url_params.permit(*Project::PROJECT_PARAMS))}' data-name='#{k}' #{disabled} #{selected}>#{v.capitalize}</option>"
    end
  end

  def property_select_options(props, url_params, aggregation)
    props.unshift("All")
    props.map do |p|
      selected = "selected" if p == url_params[:prop]
      "<option data-url='#{build_property_url(p, url_params.permit(*Project::PROJECT_PARAMS), aggregation)}' data-name='#{p.parameterize}' #{selected}>#{p}</option>"
    end
  end

  def date_select_options(url_params, aggregation)
    Event::DATE_OPTIONS.map do |k, v|
      selected = "selected" if k == url_params[:date]
      "<option data-url='#{build_date_url(k, url_params.permit(*Project::PROJECT_PARAMS), aggregation)}' data-name='#{k}' #{selected}>#{v}</option>"
    end
  end

  def build_event_url(event_name, url_params, aggregation)
    project_path(
      url_params[:slug],
      url_params.except(:prop, :slug)
        .merge({ event: event_name.parameterize })
        .merge({ agg: aggregation })
    )
  end

  def build_agg_url(agg, url_params)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ agg: agg })
    )
  end

  def build_property_url(prop, url_params, aggregation)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ prop: prop }).merge({ agg: aggregation })
    )
  end

  def build_date_url(date, url_params, aggregation)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ date: date }).merge({ agg: aggregation })
    )
  end

  def build_test_toggle_url(test, url_params, aggregation)
    url_params = url_params.permit(*Project::PROJECT_PARAMS)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ test: test }).merge({ agg: aggregation })
    )
  end
  
end
