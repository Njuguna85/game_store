defmodule PentoWeb.AdminDashboardLiveTest do
  # This allows us to route to live views using the test connection
  # Using this behaviour give our test access to a context map with a key of :conn pointing to a value of test connection
  use PentoWeb.ConnCase

  # import this to give us access to LiveView Testing functions
  import Phoenix.LiveViewTest
  alias Pento.{Accounts, Survey, Catalog}

  # define the test module.
  #

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }

  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15
  }

  @create_demographic_over_18_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 30
  }

  @create_user_attrs %{email: "test@test.com", password: "passwordpassword"}
  @create_user2_attrs %{email: "test2@test.com", password: "passwordpassword"}
  @create_user3_attrs %{email: "test3@test.com", password: "passwordpassword"}

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)

    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(user, product, stars) do
    {:ok, rating} =
      Survey.create_rating(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    rating
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_demographic(user, attrs \\ @create_demographic_attrs) do
    demographic = demographic_fixture(user, attrs)
    %{demographic: demographic}
  end

  defp create_rating(user, product, stars) do
    rating = rating_fixture(user, product, stars)
    %{rating: rating}
  end

  describe "Survey Results" do
    setup [:register_and_log_in_user, :create_product, :create_user]

    # the create product and create user functions above return maps of the created objects as the last thing
    # thus they will be merged into the current context and will be available for all subsequent setup, setup_all and test
    setup %{user: user, product: product} do
      create_demographic(user)
      create_rating(user, product, 2)

      user2 = user_fixture(@create_user2_attrs)
      create_demographic(user2, @create_demographic_over_18_attrs)
      create_rating(user2, product, 3)

      # returning :ok leaves the context unchanged
      :ok
    end

    # mount and render the live view
    # find the age group filter drop down menu and select an item from it
    # assert that the re-rendered survey results chart has the correct data and markup

    test "it filters by age group", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/admin/dashboard")
      params = %{"age_group_filter" => "18 and under"}

      assert view
             |> element("#age-group-form")
             |> render_change(params) =~ "<title>2.00</title>"
    end
  end
end
