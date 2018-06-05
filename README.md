# terraform manifests to set up nextcloud

## 2dos:

* refactor variables using
* ~~switch to prepared ami-image~~
* ~~add ELB~~
* ~~add autoscaling group~~
* ~~create security group for application rather than default~~

## problems
* database instance still uses default security group

## Short summary

It would be nice to do following:
* add detection if 'NC' is installed (check config, check 'installed' there and check database tables existance and 
  several more checks) and run occ maintenance:install with appropriate paramereters and import settings to keep
  objectstore in S3. But that's not a goal to fully automate this.
* after implementation of previous option It worth re-organize manifest to begin with separate VPC which will hold
  all relevant resources (rds, elb and so on).
* also it worth working on ELB healthchech + image warm-up time because there's a 1-6 seconds gap in "seamless" 
  update depending on health_check interval.

But that doesn't makes sense at the moment. later I definitely will get back to this and finish refactoring.

