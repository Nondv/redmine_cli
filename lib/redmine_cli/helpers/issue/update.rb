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

          update_description(issue)
          leave_comment(issue)
          update_done_ratio(issue)
          update_assigned_to(issue)
          update_status(issue)
          update_parent_issue_id(issue)

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
          issue.assigned_to_id = InputParser.parse_user(options[:assign], project: issue.project).id

        rescue UserNotFound
          @errors.push "Assigned: #{m(:not_found)}"
        end

        def update_status(issue)
          opt = options[:status]
          return unless opt

          list = Models::IssueStatus.all
          if opt.numeric?
            status = list.find { |s| s.id == opt }
            return issue.status_id = status.id if status
          end

          found_statuses = list.filter_by_name_substring(opt)
          case found_statuses.size
          when 0 then @errors.push "Status: #{m(:not_found)}"
          when 1 then issue.status_id = found_statuses.first.id
          else issue.status_id = ask_for_object(found_statuses).id
          end
        end

        def update_description(issue)
          return unless options[:description]

          issue.description = ask_from_text_editor(issue.description || '')
        end

        def leave_comment(issue)
          return unless options[:comment]

          comment = ask_from_text_editor(m('commands.issue.update.type_comment_here'))
          return if comment.strip.empty?

          issue.notes = comment
        end

        def add_time_entry_to_issue(issue)
          return unless options[:time]

          hours = InputParser.parse_time(options[:time])
          entry = Models::TimeEntry.create issue_id: issue.id,
                                           hours: hours

          return if entry.persisted?
          @errors.push "Time: #{m(:creation_error)}"

        rescue BadInputTime
          @errors.push "Time: #{m(:wrong_format)}"
        end

        def update_parent_issue_id(issue)
          return unless options[:parent_issue_id]

          parrent_issue = Models::Issue.find(options[:parent_issue_id])
          issue.parent_issue_id = parrent_issue.id
        rescue ActiveResource::ResourceNotFound
          @errors.push "ParentIssue: #{m(:not_found)}"
        end
      end
    end
  end
end
