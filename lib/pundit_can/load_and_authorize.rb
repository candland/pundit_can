require "pundit"

module PunditCan
  module LoadAndAuthorize
    extend ActiveSupport::Concern
    include Pundit::Authorization

    included do
      after_action :verify_authorized, unless: -> { respond_to?(:devise_controller?) && devise_controller? }
      after_action :verify_policy_scoped, except: [:new, :create], unless: -> { respond_to?(:devise_controller?) && devise_controller? }
    end

    class_methods do
      # skip_authorized_check
      #
      # Skip the +verify_authorized+ after action for the provided actions
      #
      # @example
      #
      #   skip_authorized_check :new, :edit
      #
      # @param [*Symbol] actions
      #
      def skip_authorized_check *actions
        if actions.any?
          skip_after_action :verify_authorized, only: actions
        end
      end

      # skip_scoped_check
      #
      # Skip the +verify_policy_scoped+ after action for the provided actions
      #
      # @example
      #
      #   skip_scoped_check :new, :edit
      #
      # @param [*Symbol] actions
      #
      def skip_scoped_check *actions
        if actions.any?
          skip_after_action :verify_policy_scoped, only: actions
        end
      end

      # load_resource
      #
      # @example
      #
      #   load_resource
      #
      # @example
      #
      #   load_resource instance_name: :user, model_class: User, param_key: :user_id, parent: true
      #
      # @param [String] instance_name Optional. Defaults from the +model_class+ if
      # provided, otherwise from the controller name.
      #
      # @param [Constant] model_class Optional. Tries to create model from the controller name when missing.
      #
      # @param [String] param_key Optional. The key for the Id in params. Defaults to +:id+, otherwise tries
      # to guess from the +instance_name+ or +model_class+.
      #
      # @param [Boolean] parent Optional. Changes the loading for parent classes. Default +false+
      #
      # @param [Constant] policy_class Optional. The policy class to use. Defaults from controller name.
      #
      # @param [Constant] policy_scope_class Optional. The policy scope class to use. Defaults from controller name.
      #
      def load_resource **options
        before_action(**options.extract!(:only, :except, :if, :unless)) do
          load_scoped(**options)
        end
      end
    end

    private

    def resource_class_name
      self.class.name[0..-11].singularize.demodulize
    end

    def load_scoped **options
      model_class = options[:model_class] || resource_class_name.demodulize.constantize
      instance_name = (options[:instance_name] || model_instance_name(options) || resource_class_name.underscore).to_s
      param_key = get_param_key(options, instance_name, model_class)

      loaded = if options[:parent]
        load_parent_instance_var(model_class, param_key, options.extract!(:policy_class), options.extract!(:policy_scope_class))
      else
        load_instance_var(model_class, param_key, options.extract!(:policy_class), options.extract!(:policy_scope_class))
      end

      instance_name = instance_name.pluralize unless loaded.is_a?(model_class)
      instance_variable_set("@#{instance_name}", loaded)
    end

    def get_param_key options, instance_name, model_class
      if options[:parent]
        options.fetch(:param_key, :"#{instance_name || model_class&.name&.underscore}_id")
      else
        options.fetch(:param_key, :id)
      end
    end

    # if a model_name option is given use that otherwise nil
    # and is parent
    def model_instance_name options
      options[:model_class].name.underscore if options[:model_class].present? && options[:parent]
    end

    def load_instance_var model_class, param_key, policy_kwopts, policy_scope_kwopts
      case params[:action]
      when "index"
        load_scope(model_class, policy_kwopts, policy_scope_kwopts)
      when "new"
        authorize(model_class.new, **policy_kwopts)
      when "create"
        authorize(model_class.new(permitted_attributes(model_class)), **policy_kwopts)
      when "edit", "update", "show", "destroy"
        load_model(model_class, param_key, policy_kwopts, policy_scope_kwopts)
      else
        if params[param_key]
          load_model(model_class, param_key, policy_kwopts, policy_scope_kwopts)
        else
          load_scope(model_class, policy_kwopts, policy_scope_kwopts)
        end
      end
    end

    def load_parent_instance_var model_class, param_key, policy_kwopts, policy_scope_kwopts
      if params[param_key]
        load_model(model_class, param_key, policy_kwopts, policy_scope_kwopts, :show?)
      end
    end

    def load_model model_class, param_key, policy_kwopts, policy_scope_kwopts, query = nil
      authorize(policy_scope(model_class, **policy_scope_kwopts).find(params[param_key]), query, **policy_kwopts)
    end

    def load_scope model_class, policy_kwopts, policy_scope_kwopts
      authorize(policy_scope(model_class, **policy_scope_kwopts), **policy_kwopts)
    end
  end
end
