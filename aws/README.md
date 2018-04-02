* Key Rotation Scripts for AWS

**rotate-iam-key.sh** is a bash script that rotates an IAM user's key. The script follows the process below to rotate the key:

1. Create a new (second) access key for the user.
2. Test the application code with the new key.
3. If nothing breaks, de-activate the old key.
4. Re-test.
5. If nothing breaks, delete the old key.

The script does a fairly simple test in step #4: it merely attempts to get an object from S3, and if it’s successful,
the test passes. The actual tests used in your production environment will likely be more extensive and will vary based
on your business requirements.

The rotate-iam-key.sh script accepts the following command line options:

    usage: rotate-iam-user-key.sh [options...]
    options:
     -a --aws-key-file  The file for the .csv access key file for an AWS administrator. Required. The AWS administrator must
                        have the rights to list and update credentials for the IAM user. The script expects the .csv format
                        used when you dowload the key from IAM in the AWS console.
     -s --s3-test-file  Specifies a test text file stored in S3 used for testing. Required. The IAM user must have
                        GET access to this file.
     -c --csv-key-file  The name of the output .csv file containing the new access key information. Optional.
     -u --user          The IAM user whose key you want to rotate. Required.
     -j --json          A file to send JSON output to. Optional.
        --help          Prints this help message
