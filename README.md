# Toggler

[![Gem Version](https://badge.fury.io/rb/test_toggler.svg)](https://badge.fury.io/rb/test_toggler)

Toggler is a microtool for tests in Ruby, where the core of the test is shared throughout many tests, and it only differs in little variations.

Example:

```ruby
def test_service_returns_true_on_the_green_path
  set_system_beta_flag(
    my_feature: true,
    my_feature_killswitch: false,
  )
  service = make_service(
    AUTH_ALL,
    make_valid_user(valid_user_name),
  )

  service.add_input(foo)
  service.set_data(bar)

  result = service.run
  assert(result)
end
```

Then the rest of the test are the same except a few lines here and there:

```ruby
def test_service_returns_false_when_MY_FEATURE_beta_is_false
  set_system_beta_flag(
    my_feature: false,
    # ... same
  )
  # ... same
  refute(result)
end
```

This requires a lot of copy and a lot of maintenance when the service evolves.

With `Toggler` this looks like:

```ruby
class ServiceTest < Minitest::TestCase
  def setup
    @scenario = Toggler::Scenario.new(
      default_args: {
        my_feature: true,
        my_feature_killswitch: false,
        auth: AUTH_ALL,
        username: valid_user_name,
        input: foo,
        data: bar,
      }
    ) do |args|
        set_system_beta_flag(
          my_feature: args[:my_feature],
          my_feature_killswitch: args[:my_feature_killswitch],
        )
        service = make_service(
          args[:auth],
          make_valid_user(args[:username]),
        )

        service.add_input(args[:input])
        service.set_data(args[:data])

        service.run
    end
  end
end
```

And the happy path:

```ruby
def test_service_returns_true_on_the_green_path
  @scenario.expect do |result|
    assert(result)
  end
end
```

And each "toggled" test:

```ruby
def test_service_returns_false_when_MY_FEATURE_beta_is_false
  @scenario.with_args(my_feature: false) do |result|
    refute(result)
  end
end
```
