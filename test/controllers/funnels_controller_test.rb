# frozen_string_literal: true

require "test_helper"

class FunnelsControllerTest < ActionDispatch::IntegrationTest
  def project_setup
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, user: @user)
    FactoryBot.create(:api_key, project: @project, test: true)
    @api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
  end

  def basic_setup
    project_setup
    @event1 = FactoryBot.create(:event, api_key: @api_key_live)
    @event2 = FactoryBot.create(:event, api_key: @api_key_live)
    @event3 = FactoryBot.create(:event, api_key: @api_key_live)
  end

  class GetIndex < FunnelsControllerTest
    setup do
      basic_setup
      sign_in @user
      get user_project_funnels_path(@user.hash_id, @project.name)
    end

    test "is succesful" do
      assert_response :success
    end

    test "contains correct body" do
      assert_match("You haven't created any funnels", @response.body)
    end
  end

  class GetShow < FunnelsControllerTest
    setup do
      basic_setup
      sign_in @user
      @funnel = FactoryBot.create(:funnel, api_key: @api_key_live)
    end

    test "is succesful" do
      get user_project_funnel_path(@user.hash_id, @project.name, @funnel.name.parameterize)
      assert_response :success
    end

    test "contains correct funnel name in dropdown" do
      get user_project_funnel_path(@user.hash_id, @project.name, @funnel.name.parameterize)
      assert_match("data-name='#{@funnel.name.parameterize}'", @response.body)
    end

    test "redirect to index if no funnel with that name" do
      get user_project_funnel_path(@user.hash_id, @project.name, "no-funnel")
      assert_redirected_to user_project_funnels_path(@user.hash_id, @project.name)
    end

    test "redirect to index if no test funnel" do
      get user_project_funnel_path(@user.hash_id,
                                   @project.name,
                                   @funnel.name.parameterize,
                                   params: { test: true })
      assert_redirected_to user_project_funnels_path(@user.hash_id,
                                                     @project.name,
                                                     params: { test: true })
    end

    test "redirect to first test funnels no test funnel with this name" do
      api_key_test = @project.api_key_test
      FactoryBot.create(:event, api_key: api_key_test)
      funnel_test = FactoryBot.create(:funnel, api_key: api_key_test)

      get user_project_funnel_path(@user.hash_id, @project.name, "no-funnel",
                                   params: { test: true })
      follow_redirect!
      assert_redirected_to user_project_funnel_path(@user.hash_id,
                                                    @project.name,
                                                    funnel_test.name.parameterize,
                                                    params: { test: true })
    end
  end

  class GetShowPublic < FunnelsControllerTest
    setup do
      basic_setup
      @project.update(public: true)
      @funnel = FactoryBot.create(:funnel, api_key: @api_key_live)
    end

    test "is succesful for public" do
      get user_project_funnel_path(@user.hash_id, @project.name, @funnel.name.parameterize)
      assert_response :success
    end

    test "doesn't contain footer for public" do
      get user_project_funnel_path(@user.hash_id, @project.name, @funnel.name.parameterize)
      assert_no_match("Settings", @response.body)
    end
  end

  class GetNew < FunnelsControllerTest
    setup do
      project_setup
      sign_in @user
      get new_user_project_funnel_path(@user.hash_id, @project.name)
    end

    test "is successful" do
      assert_response :success
    end

    test "contains correct title" do
      assert_match("Create new funnel", @response.body)
    end
  end

  class PostCreate < FunnelsControllerTest
    setup do
      basic_setup
      sign_in @user
      @funnel_attributes = {
        name: "My Funnel",
        funnel_steps_attributes: attributes_for_list(:funnel_step, 5)
      }
    end

    test "is successful" do
      post user_project_funnels_path(@user.hash_id, @project.name,
                                     params: { funnel: @funnel_attributes })
      assert_redirected_to user_project_funnel_path(@user.hash_id,
                                                    @project.name,
                                                    @funnel_attributes[:name].parameterize)
    end

    test "created new funnel with correct name" do
      post user_project_funnels_path(@user.hash_id,
                                     @project.name,
                                     params: { funnel: @funnel_attributes })
      assert_not_empty(Funnel.where(name: @funnel_attributes[:name]))
    end

    test "created correct number of funnel steps" do
      post user_project_funnels_path(@user.hash_id,
                                     @project.name,
                                     params: { funnel: @funnel_attributes })
      assert_equal(
        Funnel.find_by(name: @funnel_attributes[:name]).funnel_steps.count,
        @funnel_attributes[:funnel_steps_attributes].length
      )
    end

    test "redirects to form" do
      @funnel_attributes[:funnel_steps_attributes] = []
      post user_project_funnels_path(@user.hash_id,
                                     @project.name,
                                     params: { funnel: @funnel_attributes })
      assert_redirected_to new_user_project_funnel_path(@user.hash_id, @project.name)
    end

    test "show error message in flash" do
      @funnel_attributes[:funnel_steps_attributes] = []
      post user_project_funnels_path(@user.hash_id,
                                     @project.name,
                                     params: { funnel: @funnel_attributes })
      follow_redirect!
      assert_match("We couldn&#39;t create your funnel:", @response.body)
    end

    test "doesn't create funnel in database" do
      @funnel_attributes[:funnel_steps_attributes] = []
      assert_no_difference -> { Funnel.count } do
        post user_project_funnels_path(@user.hash_id,
                                       @project.name,
                                       params: { funnel: @funnel_attributes })
      end
    end
  end
end
