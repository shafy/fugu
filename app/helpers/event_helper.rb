# frozen_string_literal: true

module EventHelper
  def event_select_options(url_params, aggregation, event_names)
    event_names.map do |e|
      selected = "selected" if e.parameterize == url_params[:slug]
      "<option data-url='#{build_event_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, e)}' data-name='#{e.parameterize}' #{selected}>#{e}</option>"
    end
  end

  def funnel_select_options(url_params, funnel_names)
    funnel_names.map do |f|
      selected = "selected" if f.parameterize == url_params[:slug]
      "<option data-url='#{build_funnel_url(url_params.permit(*Funnel::FUNNEL_PARAMS), f)}' data-name='#{f.parameterize}' #{selected}>#{f}</option>"
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

  def date_select_options(url_params, aggregation, chart_type)
    default_to_week = Event::DATE_OPTIONS.exclude?(url_params[:date])
    Event::DATE_OPTIONS.map do |k, v|
      selected = "selected" if (default_to_week && k == "7d") || k == url_params[:date]
      "<option data-url='#{build_date_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, k, chart_type)}' data-name='#{k}' #{selected}>#{v}</option>"
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

  def build_funnel_url(url_params, funnel_name)
    project_funnel_path(
      url_params[:project_slug],
      funnel_name.parameterize,
      url_params.except(:prop, :project_slug, :slug)
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

  def build_date_url(url_params, aggregation, date, chart_type)
    case chart_type
    when "event"
      project_event_path(
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug).merge({ date: date }).merge({ agg: aggregation })
      )
    when "funnel"
      project_funnel_path(
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug).merge({ date: date })
      )
    end
  end

  # rubocop:disable Metrics/MethodLength(RuboCop)
  def build_test_toggle_url(url_params, aggregation, test, chart_type)
    case chart_type
    when "event"
      url_params = url_params.permit(*Event::EVENT_PARAMS)
      project_event_path(
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug).merge({ test: test }).merge({ agg: aggregation })
      )
    when "funnel"
      url_params = url_params.permit(*Funnel::FUNNEL_PARAMS)
      project_funnel_path(
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug).merge({ test: test })
      )
    end
  end
  # rubocop:enable Metrics/MethodLength(RuboCop)
end
