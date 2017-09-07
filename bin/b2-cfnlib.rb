require 'optparse'
require_relative '../lib/cf_common'
require_relative '../lib/cf_start_stop_environment'
require 'logger'

def print_usage_exit(code)
  STDERR.puts(File.open("#{File.expand_path(File.dirname(__FILE__))}/usage.txt").read)
  exit code
end

$options = {}
$options['SOURCE_BUCKET'] = ENV['SOURCE_BUCKET']
$options['AWS_ASSUME_ROLE'] = ENV['AWS_ASSUME_ROLE']

$log = Logger.new(STDOUT)

# always flush output
STDOUT.sync = true

OptionParser.new do |opts|

  opts.banner = "Usage: b2-cfnlib [command] [options]"

  opts.on('--source-bucket [BUCKET]') do |bucket|
    $options['SOURCE_BUCKET'] = bucket
    ENV['SOURCE_BUCKET'] = bucket
  end

  opts.on('--aws-role [ROLE]') do |role|
    ENV['AWS_ASSUME_ROLE'] = role
  end

  opts.on('--stack-name [STACK_NAME]') do |stack|
    $options['STACK'] = stack
  end

  opts.on('--asg-name [ASG]') do |asg|
    $options['ASG'] = asg
  end

  opts.on('--rds-instance-id [RDS_INSTANCE_ID]') do |asg|
    $options['RDS_INSTANCE_ID'] = asg
  end

  opts.on('--stack-name [STACK_NAME]') do |asg|
    $options['STACK_NAME'] = asg
  end

  opts.on('-r [AWS_REGION]','--region [AWS_REGION]') do |region|
    ENV['AWS_REGION'] = region
  end

  opts.on('-p [AWS_PROFILE]','--profile [AWS_PROFILE]') do |profile|
    ENV['AWS_PROFILE'] = profile
  end

  opts.on('--dry-run') do
    ENV['DRY_RUN'] = '1'
  end

end.parse!

# Backward compatibility with environment variable names

if not ENV['AWS_ASSUME_ROLE'].nil?
  ENV['CF_MANAGE_AWS_PROFILE'] = ENV['AWS_ASSUME_ROLE']
end

command = ARGV[0]

if command.nil?
  print_usage_exit(-1)
end

# execute action based on command
case command
  # asg commands
  when 'stop-asg'
    Base2::CloudFormation::EnvironmentRunStop.new().start_stop_asg('stop', $options['ASG'])
  when 'start-asg'
    Base2::CloudFormation::EnvironmentRunStop.new().start_stop_asg('start', $options['ASG'])

  # rds commands
  when 'stop-rds'
    Base2::CloudFormation::EnvironmentRunStop.new().start_stop_rds('stop', $options['RDS_INSTANCE_ID'])
  when 'start-rds'
    Base2::CloudFormation::EnvironmentRunStop.new().start_stop_rds('start', $options['RDS_INSTANCE_ID'])

  # stack commands
  # rds commands
  when 'stop-environment'
    Base2::CloudFormation::EnvironmentRunStop.new().stop_environment($options['STACK_NAME'])
  when 'start-environment'
    Base2::CloudFormation::EnvironmentRunStop.new().start_environment($options['STACK_NAME'])
end