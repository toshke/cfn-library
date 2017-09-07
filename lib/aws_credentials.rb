require 'aws-sdk'

module Base2

  class AWSCredentials

    def self.get_stack_operation_credentials(session_name)

      session_name = "#{session_name.gsub('_', '-')}-#{Time.now.getutc.to_i}"
      if session_name.length > 64
        session_name = session_name[-64..-1]
      end

      if not ENV['CF_MANAGE_AWS_PROFILE'].nil?
        $log.info("Using AWS Credentials from shared profile #{ENV['CF_MANAGE_AWS_PROFILE']}")
        return Aws::SharedCredentials.new(profile_name: ENV['CF_MANAGE_AWS_PROFILE'])
      end

      # passed as role from account mappings
      if not ENV['CF_MANAGE_ACCOUNT_NAME'].nil?
        account = ENV['CF_MANAGE_ACCOUNT_NAME']
        account_id = config['accounts'][account]
        role_arn = "arn:aws:iam::#{account_id}:role/ciinabox"
        $log.info("Using AWS Credentials assumed from role arn:aws:iam::#{account_id}:role/ciinabox")
        return Aws::AssumeRoleCredentials.new(role_arn: role_arn,
                                              role_session_name: session_name)

      end

      # passed as role arn
      if not ENV['CF_MANAGE_ROLE_ARN'].nil?
        $log.info("Using AWS Credentials assumed from role #{ENV['CF_MANAGE_ROLE_ARN']}")

        return Aws::AssumeRoleCredentials.new(role_arn: ENV['CF_MANAGE_ROLE_ARN'],
                                              role_session_name: session_name)
      end

      return nil

    end
  end
end