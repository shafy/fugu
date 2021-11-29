# frozen_string_literal: true

module ProjectHelper
  def event_select_options(event_names, url_params)
    event_names.map do |e|
      "<option data-url='#{build_event_url(e, url_params.permit(*Project::PROJECT_PARAMS))}' data-name='#{e.parameterize}'>#{e}</option>"
    end
  end

  def agg_select_options(url_params)
    Event::AGGREGATIONS.map do |k, v|
      "<option data-url='#{build_agg_url(k, url_params.permit(*Project::PROJECT_PARAMS))}' data-name='#{k}'>#{v.capitalize}</option>"
    end
  end

  def property_select_options(props, url_params)
    props.unshift("All")
    props.map do |p|
      "<option data-url='#{build_property_url(p, url_params.permit(*Project::PROJECT_PARAMS))}' data-name='#{p.parameterize}'>#{p}</option>"
    end
  end

  def date_select_options(url_params)
    Event::DATE_OPTIONS.map do |k, v|
      "<option data-url='#{build_date_url(k, url_params.permit(*Project::PROJECT_PARAMS))}' data-name='#{k}'>#{v}</option>"
    end
  end

  def build_event_url(event_name, url_params)
    project_path(
      url_params[:slug],
      url_params.except(:prop, :slug).merge({ event: event_name.parameterize })
    )
  end

  def build_agg_url(agg, url_params)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ agg: agg })
    )
  end

  def build_property_url(prop, url_params)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ prop: prop })
    )
  end

  def build_date_url(date, url_params)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ date: date })
    )
  end

  def build_test_toggle_url(test, url_params)
    url_params = url_params.permit(*Project::PROJECT_PARAMS)
    project_path(
      url_params[:slug],
      url_params.except(:slug).merge({ test: test })
    )
  end
end
