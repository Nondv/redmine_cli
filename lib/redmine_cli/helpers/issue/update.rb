module RedmineCLI
  module Helpers
    module Issue
      #
      # some methods for `issue update`
      #
      module Update
        include RedmineRest
        include Helpers::Input

        private

        def update_issue(issue)
          @errors = []

          update_done_ratio(issue)
          update_assigned_to(issue)
          update_status(issue)
          leave_comment(issue)

          # it should be last, because it creates new object
          add_time_entry_to_issue(issue) if @errors.empty?

          @errors.empty?
        end

        def update_done_ratio(issue)
          return unless options[:done]
          issue.done_ratio = options[:done]
        end

        def update_assigned_to(issue)
          return unless options[:assign]

          # it can raise exception if there's no such user
          Models::User.find(options[:assign])
          issue.assigned_to_id = options[:assign]

        rescue ActiveResource::ResourceNotFound
          @errors.push "Assigned: #{m(:not_found)}"
        end

        def update_status(issue)
          return unless options[:status]

          found_statuses = Models::IssueStatus.all.filter_by_name_substring(options[:status])
          case found_statuses.size
          when 0 then @errors.push "Status: #{m(:not_found)}"
          when 1 then issue.status_id = found_statuses.first.id
          else issue.status_id = ask_for_object(found_statuses).id
          end
        end

        def leave_comment(issue)
          return unless options[:comment]

          comment = ask_from_text_editor(m('commands.issue.update.type_comment_here'))
          return if comment.strip.empty?

          issue.notes = comment
        end

        def add_time_entry_to_issue(issue)
          return unless options[:time]

          hours = parse_time(options[:time])
          entry = Models::TimeEntry.create issue_id: issue.id,
                                           hours: hours

          return if entry.persisted?
          @errors.push "Time: #{m(:creation_error)}"

        rescue BadInputTime
          @errors.push "Time: #{m(:wrong_format)}"
        end
      end
    end
  end
end
