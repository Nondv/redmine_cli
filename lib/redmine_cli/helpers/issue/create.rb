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
          set_project
          set_tracker
          set_subject
          set_description
          set_assignee
        end

        def set_project
          puts Unicode.upcase(m(:projects)) + ':'
          @project = ask_for_object(Models::Project.all)
          @issue.project_id = @project.id
        end

        def set_tracker
          puts Unicode.upcase(m(:trackers)) + ':'
          @issue.tracker_id = ask_for_object(@project.trackers).id
        end

        def set_subject
          @issue.subject = ask m('commands.issue.create.enter_subject'),
                               required: true
        end

        def set_description
          message = m('commands.issue.create.write_description')
          input = ask_from_text_editor(message)
          @issue.description = input if input.present? && input != message
        end

        def set_assignee
          puts m('commands.issue.create.assign_to')
          @assignee = ask_for_object(@project.members)
          @issue.assigned_to_id = @assignee.id
        end
      end
    end
  end
end
