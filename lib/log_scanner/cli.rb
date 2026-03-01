require "optparse"
require_relative "version"

module LogScanner
  class CLI
    def initialize(argv)
      @argv = argv
      @options = {}
    end

    def run
      @options = parse_options
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: log-scanner [options] [file]"
        opts.separator ""
        opts.separator "Options:"

        opts.on("-f FILE", "--file=FILE", "Log file to scan (default: STDIN)") do |f|
          @options[:file] = f
        end

        opts.on("-t TAG", "--tag=TAG", "Filter by tag (e.g. DEBUG, INFO)") do |t|
          @options[:tag] = t
        end

        opts.on("-i ID", "--id=REQUEST_ID", "Filter by request ID") do |i|
          @options[:id] = i
        end

        opts.on("-s TIME", "--since=TIME", "Filter by timestamp (show lines at or after TIME)") do |s|
          @options[:since] = s
        end

        opts.on("-l LOGGERNAME", "--logger=LOGGERNAME", "Filter by logger name substring") do |l|
          @options[:logger] = l
        end

        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit
        end

        opts.on("-v", "--version", "Show version") do
          puts LogScanner::VERSION
          exit
        end
      end.parse!(@argv)

      @options
    end
  end
end
