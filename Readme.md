`bundle`, but always uses a matching bundler version.

Usage
=======

```Bash
gem install matching_bundle
matching_bundle exec rake
```

```
# .travis.yml
install: gem i matching_bundle && matching_bundle install
script: matching_bundle exec rake spec
```

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/matching_bundle.svg)](https://travis-ci.org/grosser/matching_bundle)
[![coverage](https://img.shields.io/badge/coverage-100%25-success.svg)](https://github.com/grosser/single_cov)
