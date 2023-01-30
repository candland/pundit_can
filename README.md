# PunditCan

[Pundit](https://github.com/varvet/pundit) with [cancan](https://github.com/CanCanCommunity/cancancan)
style load_and_authorize functionality.

## Usage

Include `PunditCan::LoadAndAuthorize` into `ApplicationController` or in each controller.

Call `load_resource` in the controller to load and authorize the resource.

```ruby
class UsersController < ApplicationController
  load_resource
end
```

This will load `@user` from `User` using the `UserPolicy` to authorize and scope the loading.

### Advanced usage

There is support for loading multiple models. However, there isn't a `:through` option, like cancan,
instead loading still goes through Pundit scopes.

There are options to customize the loaded instance_name, model, and policy classes.

#### Parent / nested

This is a example of loading User and Posts.
```ruby
class PostsController < ApplicationController
  load_resource model_class: User, parent: true
  load_resource

  ...
end
```

That will load `@user` from the `UserPolicy` into a `User` class, using `:user_id` to find the user.
And it will lost `@post` or `@posts` using the `PostPolicy` with the `:id` param.

#### Customized loading

You can customize the loading for cases when the model, controller, and policies don't match up name-wise.
```ruby
class MisMatchedController < ApplicationController
  load_resource instance_name: :special_user,
    model_class: User,
    policy_class: SpecialUserPolicy,
    policy_scope_class: SpecialUserPolicy::Scope

  ...

  # Pundit method to override the model param key
  def pundit_params_for(record)
    params.require(:special_user)
  end
end
```

This will set `@special_user` with the `User` class, using the `SpecialUserPolicy` and
`SpecialUserPolicy::Scope` classes to authorize and scope the loading.

#### Skiping checks

By default, `verify_authorized` and `verify_policy_scoped` after actions are setup. If
you need to skip those for an action, there are `skip_authorized_check` and `skip_scoped_check`
methods to skip the verify actions for the given actions.

```ruby
class SkipsController < ApplicationController
  skip_authorized_check :index, :show
  skip_scoped_check :index, :show

  ...
end
```

## Installation

Add this line to your application's Gemfile:
```ruby
gem "pundit_can"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install pundit_can
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
