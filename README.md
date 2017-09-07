# cfn-library

Base2Services Common Cloud Formation stacks functionality

## Functionality

### Stack traversal

Used to traverse through stack and all it's substacks

### Start-stop environment functionality

Stop environment will

- Set all ASG's size to 0
- Stops RDS instances
- If RDS instance is Multi-AZ, it is converted to single-az prior it
  is being stopped

Start environment operation will

- Set all ASG's size to what was prior stop operation
- Starts ASG instances
- If ASG instance was Mutli-AZ, it is converted back to Multi-AZ

### Managing lifecycle of Cloud Formation stacks

..... TBD ....

Template location defaults to `s3://$sourceBucket/cloudformation/$projectname/$templateversion/master.json`
Check CLI parameters for setting vairables mentioned above. To override template location, use `CF_MANAGE_TEMPLATE_LOCATION`
environment variable. 


## CLI usage

You'll find usage of `/bin/b2-cfnlib.rb` within `usage.txt` file

```
Usage: b2-cfnlib [command] [options]

Commands:

b2-cfnlib stop-environment --stack-name [STACK_NAME]

b2-cfnlib start-environment --stack-name [STACK_NAME]

b2-cfnlib stop-asg --asg-name [ASG]

b2-cfnlib start-asg --asg-name [ASG]

b2-cfnlib stop-rds --rds-instance-id [RDS_INSTANCE_ID]

b2-cfnlib start-rds --rds-instance-id [RDS_INSTANCE_ID]


General options

--source-bucket [BUCKET]

    Bucket used to store / pull information from

--aws-role [ROLE_ARN]

    AWS Role to assume when performing start/stop operations.
    Reading and writing to source bucket is not done using this role. 


-r [AWS_REGION], --region [AWS_REGION]

    AWS Region to use when making API calls

-p [AWS_PROFILE], --profile [AWS_PROFILE]

    AWS Shared profile to use when making API calls

--dry-run

    Applicable only to [start|stop-environment] commands. If dry run is enabled
    info about assets being started / stopped will ne only printed to standard output,
    without any action taken.
```

Also, there are some environment variables that control behaviour of the application.
There are command line switch counter parts for all of the

`AWS_ASSUME_ROLE` as env var or `--aws-role` as CLI switch

`AWS_REGION` as env car or `-r`, `--region` as CLI switch

`AWS_PROFILE` as env var or `-p`, `--profile` as CLI switch

`SOURCE_BUCKET` as env var or `--source-bucket` as CLI switch

`DRY_RUN` as env var (set to '1' to enable) or `--dry-run` as CLI switch
