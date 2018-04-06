# rotate-access-keys

Created a repo in GitHub, [rotate-access-keys](https://github.com/ECSTeam/rotate-access-keys.git)

# Sample Execution:
```
./rotate-access-keys.sh -1 -i aws -d 15
```

# Help text:
```
usage: ./rotate-access-keys.sh.sh [options...] 
options:
 -a  AWS Access Credentials file ( defaults to ~/.aws/credentials ) 
 -i  The desired Cloud Platform (IAAS): ( azure aws gcp)
 -d  The Number of days since the last rotation, indicating expiry
     (-d 15 = 15 days and older will be rotated)
 -h  This help text
 -s  S3 Bucket filename to test access for the new keys.
 -1  Preview the users needing rotation (without making changes)
```

## If using `AWS`:
```
/rotate-access-keys.sh -1 -i aws -d 1 -s s3://morgan-test2/junk.test
```

If you wish to rotate only one known user in `AWS`, you may execute the subordinate script directly:
```
<path to repo>/rotate-access-keys/aws/rotate-iam-user-key.sh  -a ~/.aws/credentials -s s3://morgan-test2/junk.test -u morgan-concourse -j morgan-concourse.json
```
