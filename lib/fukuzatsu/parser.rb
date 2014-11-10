require 'fileutils'
require 'analyst'

module Fukuzatsu

  class Parser

    attr_reader :path_to_files, :formatter

    def initialize(path_to_files, formatter)
      @path_to_files = path_to_files
      @formatter = formatter
    end

    def report
      # TODO HERE handle index?
      summaries.uniq(&:container_name).each do |summary|
        self.formatter.new(summary: summary).export
      end
    end

    private

    def summaries
      @summaries ||= file_reader.source_files.map do |source_file|
        Fukuzatsu::Summary.from(
          content: source_file.contents,
          source_file: source_file.filename
        )
      end.flatten
    end

    def file_reader
      @file_reader ||= Fukuzatsu::FileReader.new(self.path_to_files)
    end

  end

end


  #   def reset_output_directory
  #     begin
  #       FileUtils.remove_dir(OUTPUT_DIRECTORY)
  #     rescue Errno::ENOENT
  #     end
  #     FileUtils.mkpath(OUTPUT_DIRECTORY)
  #   end

  #   def report_complexity
  #     return if self.threshold == 0
  #     complexities = self.parsed_files.map(&:complexity)
  #     return if complexities.max.to_i <= self.threshold
  #     puts "Maximum complexity of #{complexities.max} exceeds #{options['threshold']} threshold!"
  #     exit 1
  #   end

  #   def write_report_index
  #     return unless self.formatter.writes_to_file_system?
  #     puts "Results written to #{OUTPUT_DIRECTORY} "
  #     return unless self.formatter.has_index?
  #     formatter.index_class.new(parsed_files.map(&:summary), OUTPUT_DIRECTORY).export
  #   end
