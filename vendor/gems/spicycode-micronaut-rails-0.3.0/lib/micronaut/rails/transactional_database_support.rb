module Micronaut
  module Rails
    module TransactionalDatabaseSupport

      module InstanceMethods

        def active_record_configured?
          defined?(::ActiveRecord) && !::ActiveRecord::Base.configurations.blank?
        end

        def transactional_protection_start
          return unless active_record_configured?

          ::ActiveRecord::Base.connection.increment_open_transactions
          ::ActiveRecord::Base.connection.begin_db_transaction
        end

        def transactional_protection_cleanup
          return unless active_record_configured?

          if ::ActiveRecord::Base.connection.open_transactions != 0
            ::ActiveRecord::Base.connection.rollback_db_transaction
            ::ActiveRecord::Base.connection.decrement_open_transactions
          end

          ::ActiveRecord::Base.clear_active_connections!
        end

      end

      def self.extended(kls)
        kls.send(:include, InstanceMethods)
        kls.before { transactional_protection_start }
        kls.after { transactional_protection_cleanup }
      end

    end
  end
end