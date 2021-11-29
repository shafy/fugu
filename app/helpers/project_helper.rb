# frozen_string_literal: true

module ProjectHelper
  def event_select_options(event_names, url_params, day_not_allowed)
    event_names.map do |e|
      "<option data-url='#{build_event_url(e, url_params.permit(*Project::PROJECT_PARAMS), day_not_allowed)}' data-name='#{e.parameterize}'>#{e}</option>"
    end
  end

  def agg_select_options(url_params, day_not_allowed)
    Event::AGGREGATIONS.map do |k, v|
      disabled = "disabled" if k == "d" && day_not_allowed
      "<option data-url='#{build_agg_url(k, url_params.permit(*Project::PROJECT_PARAMS), day_not_allowed)}' data-name='#{k}' #{disabled}>#{v.capitalize}</option>"
    end
  end

  def property_select_options(props, url_params, day_not_allowed)
    props.unshift("All")
    props.map do |p|
      "<option data-url='#{build_property_url(p, url_params.permit(*Project::PROJECT_PARAMS), day_not_allowed)}' data-name='#{p.parameterize}'>#{p}</option>"
    end
  end

  def date_select_options(url_params, day_not_allowed)
    Event::DATE_OPTIONS.map do |k, v|
      "<option data-url='#{build_date_url(k, url_params.permit(*Project::PROJECT_PARAMS), day_not_allowed)}' data-name='#{k}'>#{v}</option>"
    end
  end

  def build_event_url(event_name, url_params, day_not_allowed)
    project_path(
      url_params[:slug],
      url_params.except(:prop, :slug)
        .merge({ event: event_name.parameterize })
        .merge(agg_clamp(url_params[:agg], day_not_allowed))
    )
  end

  def build_agg_url(agg, url_params, day_not_allowed)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge(agg_clamp(agg, day_not_allowed))
    )
  end

  def build_property_url(prop, url_params, day_not_allowed)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ prop: prop }).merge(agg_clamp(url_params[:agg], day_not_allowed))
    )
  end

  def build_date_url(date, url_params, day_not_allowed)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ date: date }).merge(agg_clamp(url_params[:agg], day_not_allowed))
    )
  end

  def build_test_toggle_url(test, url_params, day_not_allowed)
    url_params = url_params.permit(*Project::PROJECT_PARAMS)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ test: test }).merge(agg_clamp(url_params[:agg], day_not_allowed))
    )
  end

  def agg_clamp(agg, day_not_allowed)
    { agg: day_not_allowed ? "w" : agg }
  end
end
