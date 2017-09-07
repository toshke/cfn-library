require 'aws-sdk'
require_relative '../lib/cf_common'
require_relative '../lib/aws_credentials'
require 'json'
require 'yaml'

module Base2
  module CloudFormation
    class StackLifecycle

      @cf_client = nil
      @stack_name = nil
      @s3_client = nil
      @s3_bucket = nil
      @credentials = nil
      @dry_run = false

      def initialize
        @environment_resources = []
        @s3_client = Aws::S3::Client.new()
        @s3_bucket = ENV['SOURCE_BUCKET']
        @cf_client = Aws::CloudFormation::Client.new()

        @credentials = Base2::AWSCredentials.get_stack_operation_credentials('create_update_delete_cf_stack')
        if not @credentials.nil?
          @cf_client = Aws::CloudFormation::Client.new(credentials: @credentials)
        end

        @dry_run = ENV.key?('DRY_RUN') and ENV['DRY_RUN'] == '1'
      end

      # Create CFN stack
      def create
        # validate required parameters, stack name, project name and cfn template version are mandatory
        validate_environment

        # discover stack name and temlate version
        @stack_name = ENV['CF_MANAGE_STACK_NAME']
        template_version = ENV['CF_MANAGE_TEMPLATE_VERSION']
        project_name = ENV['CF_MANAGE_PROJECT_NAME']
        template_location = "cloudformation/#{}"
        # discover parameters
        # Collect parameters and tags
        create_params = []

        tags = [
            {key: 'Name', value: "#{stack_name}"},
            {key: 'CFVersion', value: "#{cf_version}"},
        ]

        ENV.each do |k, v|
          if k.start_with?('CF_MANAGE_PARAM_')
            create_params << {parameter_key: k.gsub('CF_MANAGE_PARAM_', ''), parameter_value: v}
          end

          if k.start_with?('CF_MANAGE_TAG_')
            tags << {key: k.gsub('CF_MANAGE_TAG_', ''), value: v}
          end
        end
      end

      def validate_environment
        if ENV['CF_MANAGE_TEMPLATE_VERSION'].nil? and ENV['CF_MANAGE_TEMPLATE_LOCATION'].nil?
          raise 'CloudFormation template version not set,  use CF_MANAGE_TEMPLATE_VERSION'
        end

        if ENV['CF_MANAGE_STACK_NAME'].nil?
          raise 'CloudFormation stack name not set, use CF_MANAGE_STACK_NAME'
        end
      end

      # Update CFN stack
      def update

      end

      # Delete CFN stack
      def delete

      end

    end
  end
end
