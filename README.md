### Testing

For rails tests use `bundle exec rspec spec`

For js test use `bundle exec teaspoon`

Do not ever deploy without running tests (and making sure that they are green).


If you want to use [Guard](https://github.com/guard/guard#readme) just run `bundle exec guard init` (one time) and then `bundle exec guard`

### Branches

* _master_ - main code branch. Big features should be developed separately.
* _live_ - see Deployment section below

### Test Amazon S3 account

In order to create new projects you will need Amazon s3 (https://aws.amazon.com/s3) access keys. If you have an AWS account please use your own keys.  If you do not have your own keys please contact the project manager about generating you a unique pair.


### Stripe

First, create config/initializers/stripe.rb and set Stripe api and public keys, like this:

Stripe.api_key = "sk_test_T2ueWKDCyKdoYGW4xKse4z4n"

STRIPE_PUBLIC_KEY = "pk_test_bSOp55d8esyCWQ5HPl7Luna7"

Then, run `rake db:seed` to create 4 new plans. If Stripe keys were typed correctly, then you will see this plans in Stripe dashboard (https://manage.stripe.com/account/). 

### Subdomains

We use subdomains in this project and for development need to use *stage.lvh.me:3000*. If you already have a db with data you can run *rake db:seed minimal=true* and update only url field in users table. Mac users can also use [Pow](http://pow.cx/)

### Deployment

Deploy is done with `cap deploy` command. If you meet any problems, you can try running `ssh-add` or `bundle install`.


