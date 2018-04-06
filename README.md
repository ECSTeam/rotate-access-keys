# rotate-access-keys


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
  -1  Preview the users needing rotation
```
