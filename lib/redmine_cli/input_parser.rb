module RedmineCLI
  #
  # class with some methods for user input processing
  #
  class InputParser
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
