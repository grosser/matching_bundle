Find a matching bundler version for a Gemfile and use it.
Any additional arguments are passed to bundle, so use it just like you would use bundle.

Install
=======
    gem install matching_bundle

Usage
=====
Everything works just like bundle.
If there is a specific bundler version locked in the gemfile it will be used.

    matching_bundle install
    matching_bundle exec rake
    ...

If you need sudo to install gems do something like:

    sudo matching_bundle --version # matching version is installed
    matching_bundle install        # matching version is used

TODO
====
 - parse --gemfile option
 - use highest matching version
 - add a --no-install flag so only local versions are used

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://secure.travis-ci.org/grosser/matching_bundle.png)](http://travis-ci.org/grosser/matching_bundle)
