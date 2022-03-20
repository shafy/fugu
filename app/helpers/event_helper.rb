# frozen_string_literal: true

module EventHelper
  def event_select_options(url_params, aggregation, event_names)
    event_names.map do |e|
      selected = "selected" if e.parameterize == url_params[:slug]
      event_url = build_event_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, e)
      "<option data-url='#{event_url}' data-name='#{e.parameterize}' #{selected}>#{e}</option>"
    end
  end

  def funnel_select_options(url_params, funnel_names)
    funnel_names.map do |f|
      selected = "selected" if f.parameterize == url_params[:slug]
      funnel_url = build_funnel_url(url_params.permit(*Funnel::FUNNEL_PARAMS), f)
      "<option data-url='#{funnel_url}' data-name='#{f.parameterize}' #{selected}>#{f}</option>"
    end
  end

  def agg_select_options(url_params, aggregation, possible_aggregations)
    Event::AGGREGATIONS.map do |k, v|
      disabled = "disabled" if possible_aggregations.exclude?(k)
      selected = "selected" if k == aggregation
      agg_url = build_agg_url(url_params.permit(*Event::EVENT_PARAMS), k)
      "<option data-url='#{agg_url}' data-name='#{k}' #{disabled} #{selected}>#{v.capitalize}"\
        "</option>"
    end
  end

  def property_select_options(url_params, aggregation, props)
    props.unshift("All")
    props.map do |p|
      selected = "selected" if p == url_params[:prop]
      prop_url = build_property_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, p)
      "<option data-url='#{prop_url}' data-name='#{p.parameterize}' #{selected}>#{p}</option>"
    end
  end

  def date_select_options(url_params, aggregation, chart_type)
    default_to_week = Event::DATE_OPTIONS.exclude?(url_params[:date])
    Event::DATE_OPTIONS.map do |k, v|
      selected = "selected" if (default_to_week && k == "7d") || k == url_params[:date]
      date_url = build_date_url(url_params.permit(*Event::EVENT_PARAMS), aggregation, k, chart_type)
      "<option data-url='#{date_url}' data-name='#{k}' #{selected}>#{v}</option>"
    end
  end

  def build_event_url(url_params, aggregation, event_name)
    user_project_event_path(
      url_params[:user_id],
      url_params[:project_slug],
      event_name.parameterize,
      url_params.except(:prop, :project_slug, :slug, :user_id)
        .merge({ agg: aggregation })
    )
  end

  def build_funnel_url(url_params, funnel_name)
    user_project_funnel_path(
      url_params[:user_id],
      url_params[:project_slug],
      funnel_name.parameterize,
      url_params.except(:prop, :project_slug, :slug, :user_id)
    )
  end

  def build_agg_url(url_params, agg)
    user_project_event_path(
      url_params[:user_id],
      url_params[:project_slug],
      url_params[:slug],
      url_params.except(:project_slug, :slug, :user_id).merge({ agg: agg })
    )
  end

  def build_property_url(url_params, aggregation, prop)
    user_project_event_path(
      url_params[:user_id],
      url_params[:project_slug],
      url_params[:slug],
      url_params.except(:project_slug, :slug,
                        :user_id).merge({ prop: prop }).merge({ agg: aggregation })
    )
  end

  def build_date_url(url_params, aggregation, date, chart_type)
    case chart_type
    when "event"
      user_project_event_path(
        url_params[:user_id],
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug,
                          :user_id).merge({ date: date }).merge({ agg: aggregation })
      )
    when "funnel"
      user_project_funnel_path(
        url_params[:user_id],
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug, :user_id).merge({ date: date })
      )
    end
  end

  def build_test_toggle_url(url_params, aggregation, test, chart_type)
    case chart_type
    when "event"
      url_params = url_params.permit(*Event::EVENT_PARAMS)
      user_project_event_path(
        url_params[:user_id],
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug, :user_id)
          .merge({ test: test }).merge({ agg: aggregation })
      )
    when "funnel"
      url_params = url_params.permit(*Funnel::FUNNEL_PARAMS)
      user_project_funnel_path(
        url_params[:user_id],
        url_params[:project_slug],
        url_params[:slug],
        url_params.except(:project_slug, :slug, :user_id).merge({ test: test })
      )
    end
  end
end
