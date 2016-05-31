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
          set_version
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

        def set_version
          list = [dummy_object_with_name(m(:without_version))] + @project.versions.to_a
          return if list.size == 1

          puts Unicode.upcase(m(:versions)) + ':'
          @version = ask_for_object(list)
          @issue.fixed_version_id = @version.is_a?(Models::Version) ? @version.id : nil
        end

        def set_tracker
          puts Unicode.upcase(m(:trackers)) + ':'
          @issue.tracker_id = ask_for_object(Models::Tracker.all).id
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

        def dummy_object_with_name(name)
          dummy = Object.new
          dummy.define_singleton_method(:name) { name }

          dummy
        end
      end
    end
  end
end
