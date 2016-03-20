require 'unicode'

module RedmineCLI
  module Helpers
    module Issue
      #
      # some methods for `issue create`
      #
      module Create
        include RedmineRest
        include Helpers::Input

        private

        def set_attributes
          set_tracker
        end

        def set_tracker
          puts Unicode.upcase(m(:trackers)) + ':'
          @issue.tracker_id = ask_for_object(Models::Tracker.all).id
        end
      end
    end
  end
end
