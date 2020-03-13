#!/usr/bin/env python3


# Mostly copied from wg-buildfarm by Tully Foote

from optparse import OptionParser
import sys
import subprocess
import distro

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

def get_ubuntu_version():
    return distro.name()

def is_ubuntu():
    return distro.id() == 'ubuntu'

def configure_puppet(jenkins_name, secret_key):
    """
    Configure puppet in the system slave
     - Install puppet and git
     - donwload repo
     - run puppet
    """

    # do stuff with slave
    # first, install puppet
    print("updating apt")
    if run_cmd('apt-get update'):
        return False

    print("installing puppet and stdlib module")
    # No module package in precise
    # Deprecated package in pre
    if get_ubuntu_version() == 'precise':
        if run_cmd('wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb'):
            return False
        if run_cmd('sudo dpkg -i puppetlabs-release-precise.deb'):
            return False
        if run_cmd('sudo apt-get install -y puppet'):
            return False
        if run_cmd('sudo puppet module install puppetlabs-stdlib'):
            return False
    else:
        if run_cmd('apt-get install -y puppet puppet-module-puppetlabs-stdlib'):
            return False

    print("stopping puppet")
    # stop puppet
    if run_cmd('service puppet stop'):
        return False

    print("Clearing /etc/puppet")
    if run_cmd('rm -rf /etc/puppet'):
        return False

    print("cloning puppet repo")
    if run_cmd('git clone https://github.com/j-rivero/osrf_puppet_jenkins.git  /etc/puppet'):
        return False

    print("running puppet apply site.pp")
    # FIXME This fails with the following error:
    # Error: Evaluation Error: Use of 'import' has been discontinued in favor of a manifest directory.
    if run_cmd('puppet apply /etc/puppet/manifests/site.pp', quiet=False):
        return False
 
    # TODO: New kernel if we plan to use docker.io on precise
    # BUT ... do we really want to run docker on a modified system in 
    # precise (not the same of users)

    # if get_ubuntu_version() == 'precise':
    #  print "Installing the LTS Enablement Stack on Precise for the use of docker"
    #  print " - be carefull if you are using Nvidia or ATI"
    #  if run_cmd('sudo apt-get install --install-recommends linux-generic-lts-raring xserver-xorg-lts-raring libgl1-mesa-glx-lts-raring'):
    #      return False
    #  print " + LTS Enablement Stack installed. Please reboot"

    return True


parser = OptionParser()

# TODO: use two arguments to complete information in /etc/defaults/jenkins-slave

#(options, args) = parser.parse_args()
#if len(args) != 2:
#    parser.error("Run install <node_name> <secret_token")

#configure_puppet(args[0], args[1])

if not is_ubuntu():
    print("Not ubuntu systems are not supported")
    sys.exit(-1)

configure_puppet('foo','foo')

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
