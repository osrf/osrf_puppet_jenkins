#!/usr/bin/env python

# Mostly copied from wg-buildfarm by Tully Foote

from optparse import OptionParser
import sys
import subprocess

def run_cmd(cmd, quiet=True, extra_args=None, feed=None):
    args = {'shell': True}
    if quiet:
        args['stderr'] = args['stdout'] = subprocess.PIPE
    if feed is not None:
        args['stdin'] = subprocess.PIPE
    if extra_args is not None:
        args.update(extra_args)
    p = subprocess.Popen(cmd, **args)
    if feed is not None:
        p.communicate(feed)
    return p.wait()


def configure_puppet(jenkins_name, secret_key):
    """
    Configure puppet in the system slave
     - Install puppet and git
     - donwload repo
     - run puppet
    """

    # do stuff with slave
    # first, install puppet
    print "updating apt"
    if run_cmd('apt-get update'):
        return False
    print "installing puppet and git"
    if run_cmd('apt-get install -y puppet git-core'):
        return False

    print "stopping puppet"
    # stop puppet
    if run_cmd('service puppet stop'):
        return False

    print "Clearing /etc/puppet"
    if run_cmd('rm -rf /etc/puppet'):
        return False

    print "cloning puppet repo"
    if run_cmd('git clone https://github.com/j-rivero/osrf_puppet_jenkins.git  /etc/puppet'):
        return False

 
    # print "Copying cron rule"
    # do_scp(ip, 'identity/cron.puppet', '/etc/cron.d/puppet')

    return True


parser = OptionParser()

#parser.add_option('--do-no-destroy', dest='do_not_destroy', default=False)

(options, args) = parser.parse_args()
if len(args) != 2:
    parser.error("Run install <node_name> <secret_token")

configure_puppet(args[0], args[1])

# connect to jenkins
#try:
#    jenkins_inst = jenkins.Jenkins(jenkins_config['url'], jenkins_config['username'], jenkins_config['password'])
#    call the API to make sure we're authenticated.  This will except if the login is incorrect. 
#    jobs = jenkins_inst.get_jobs()
#except urllib2.URLError, ex:
#    print "Failed to connect to server %s:"%jenkins_config['url'], ex
#    sys.exit(1)
#except jenkins.JenkinsException, ex:
#    print "failed to connect to jenkins, not creating new jobs.  Please check username and password. ", ex
#    sys.exit(1)
