#! /bin/bash

#
# This is a prototype script for testing vagrant-hostmanager on travis-ci
#  
# TODO Implement proper test framework. rspec?
#

BASEPATH=`dirname $0`
cd $BASEPATH

HOST_REGEX='10\.0\.5\.2\tfry test-alias'
GREP_COMMAND='grep -q -P "$HOST_REGEX" /etc/hosts'

echo "Bringing up server1..."         	&& bundle exec vagrant up server1
echo "Testing hosts file on server1..."	&& bundle exec vagrant ssh server1 -c '$GREP_COMMAND' || exit $?
echo "Testing hosts file on host..."    && eval $GREP_COMMAND || exit $?
echo "Destroying server1..."         	&& bundle exec vagrant destroy -f server1
echo "Done!"