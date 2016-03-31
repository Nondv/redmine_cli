module RedmineCLI
  #
  # class with some methods for user input processing
  #
  class InputParser
    extend Helpers::Input

    #
    # Processes string and tries to find user
    #
    # @return [RedmineRest::Models::User]
    # @raise [UserNotFound]
    #
    def self.parse_user(value, project: nil)
      return RedmineRest::Models::User.find(value) if value.numeric? || value == 'current'
      fail UserNotFound unless project

      user_from_project(project, value)

    rescue ActiveResource::ResourceNotFound
      raise UserNotFound
    end

    def self.user_from_project(project, name_substring = '')
      found_members = project.members.filter_by_name_substring(name_substring)

      case found_members.size
      when 0 then fail(UserNotFound)
      when 1 then found_members.first
      else ask_for_object(found_members)
      end
    end

    #
    # Parses time from user's input.
    # Formats: HH:MM; M; H.h
    #
    # @param input [String]
    #
    def self.parse_time(input)
      fail(BadInputTime) unless input =~ /^\d+[\:\.]?\d*/

      if input.include?(':')
        h, m = input.split(':').map(&:to_i)
        (60 * h + m) / 60.0
      elsif input.include?('.')
        input.to_f
      else
        input.to_i
      end
    end
  end
end
