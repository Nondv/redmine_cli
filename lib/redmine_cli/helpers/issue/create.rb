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
          set_subject
        end

        def set_tracker
          puts Unicode.upcase(m(:trackers)) + ':'
          @issue.tracker_id = ask_for_object(Models::Tracker.all).id
        end

        def set_subject
          @issue.subject = ask m('commands.issue.create.enter_subject'),
                               required: true
        end
      end
    end
  end
end
