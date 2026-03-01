# frozen_string_literal: true

require 'optparse'
require_relative 'version'

module LogScanner
  class CLI
    FILTER_OPTS = %i[id tag since logger].freeze

    def initialize(argv)
      @argv = argv
      @opts = {}
      @current_line = nil
      @lines = []
    end

    def run
      @opts = parse_options
      if @opts.is_a?(OptionParser::ParseError)
        puts "Error parsing opts: #{@opts.message}"
        return
      end

      if @opts == {}
        puts 'No opts provided. Use -h for help.'
        return
      end

      puts "Scanning logs with opts: #{@opts.inspect}"
      read.each_line do |line|
        @current_line = line

        consume_or_skip(:id)
        consume_or_skip(:tag)
      end

      puts @lines
    end

    private

    def consume_or_skip(opt)
      @lines << @current_line if @opts[opt].nil? || @opts[opt].empty?

      return unless @opts[opt] && send("#{opt}?")

      @lines << @current_line
    end

    def id?
      return false unless @opts[:id]
      return false unless @current_line

      @current_line.include?(@opts[:id])
    end

    def tag?
      return false unless @opts[:tag]
      return false unless @current_line

      @current_line.include?(@opts[:tag])
    end

    def read
      if @opts[:file]
        File.open(@opts[:file], 'r')
      else
        $stdin
      end
    end

    def parse_options
      OptionParser.new do |opts|
        opts.banner = 'Usage: log-scanner [opts] [file]'
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-f FILE', '--file=FILE', 'Log file to scan (default: STDIN)') do |f|
          @opts[:file] = f
        end

        opts.on('-t TAG', '--tag=TAG', 'Filter by tag (e.g. DEBUG, INFO)') do |t|
          @opts[:tag] = t
        end

        opts.on('-i ID', '--id=REQUEST_ID', 'Filter by request ID') do |i|
          @opts[:id] = i
        end

        opts.on('-s TIME', '--since=TIME', 'Filter by timestamp (show lines at or after TIME)') do |s|
          @opts[:since] = s
        end

        opts.on('-l LOGGERNAME', '--logger=LOGGERNAME', 'Filter by logger name substring') do |l|
          @opts[:logger] = l
        end

        opts.on('-h', '--help', 'Show this help message') do
          puts opts
          exit
        end

        opts.on('-v', '--version', 'Show version') do
          puts LogScanner::VERSION
          exit
        end
      end.parse!(@argv)

      @opts
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
      e
    end
  end
end
