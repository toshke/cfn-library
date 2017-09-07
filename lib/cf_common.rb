require 'fileutils'
require 'yaml'
require_relative './utils'

module Base2

  module CloudFormation

    class Common

      ## Read and merge all YAML files witin config folder, and return as Hash
      def self.get_local_configuration()
        config = {}

        # Read configuration
        extra_files = Dir['config/*.yml']
        extra_files.each do |extra_file|
          if not extra_file.include?('default_params.yml')
            config = Base2::Common::CollectionHelper.deep_merge(config, YAML.load(File.read(extra_file)))
          end
        end

        config
      end

      def self.visit_stack(cf_client, stack_name, handler, visit_substacks)
        stack_resources = cf_client.describe_stack_resources(stack_name: stack_name)
        stack = cf_client.describe_stacks(stack_name: stack_name)

        # call traverse handler for parent stack
        handler.call(stack['stacks'][0].stack_name)

        # do not traverse unless instructed
        return unless visit_substacks

        stack_resources['stack_resources'].each do |resource|
          # test if resource us substack
          unless (resource['physical_resource_id'] =~ /arn:aws:cloudformation:(.*):stack\/(.*)/).nil?
            # call recursively
            self.visit_stack(cf_client, resource['physical_resource_id'], handler, visit_substacks)
          end
        end
      end
    end
  end
end
