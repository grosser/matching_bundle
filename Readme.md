Find a matching bundler version for a Gemfile and use it.<br/>
Any additional arguments are passed to bundle, so use it just like you would use bundle.

Install
=======
    gem install matching_bundle

Usage
=====
Everything works just like bundle.<br/>
If bundler is locked in the Gemfile, this version is used<br/>
If bundler is not locked in the Gemfile, normal bundler is used.

    matching_bundle install
    matching_bundle exec rake
    ...

If you need sudo to install gems do something like:

    sudo matching_bundle --version # matching bundler version is installed using sudo
    matching_bundle install        # matching version is used, no more sudo needed

TODO
====
 - parse --gemfile option which is passed to bundler, and read from this Gemfile
 - add a --no-install flag so only local versions are used

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://secure.travis-ci.org/grosser/matching_bundle.png)](http://travis-ci.org/grosser/matching_bundle)
