module Rna
  class Tasks
    def self.init(project_root=".",options={})
      puts "Settin up rna project" unless options[:quiet]
      FileUtils.mkdir("#{project_root}/config") unless File.exist?("#{project_root}/config")
      %w/rna.rb s3.yml/.each do |name|
        source = File.expand_path("../../files/#{name}", __FILE__)
        dest = "#{project_root}/config/#{File.basename(source)}"
        if File.exist?(dest)
          puts "already exists: #{dest}" unless options[:quiet]
        else
          puts "creating: #{dest} from #{source}" unless options[:quiet]
          FileUtils.cp(source, dest)
        end
      end
    end
    def self.build(options)
      new(options).build
    end

    def initialize(options={})
      @options = options
      @dsl = DSL.new(@options[:config_path])
    end
    def build
      @dsl.evaluate
      @dsl.build
      @dsl.output(@options)
    end
  end
end