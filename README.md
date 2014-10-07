# OSRF puppet for jenkins slaves 

Puppet configuration to set up build.osrfoundation.org jenkins slaves

## Usage

 * Create the node in Jenkins
 * Go into the new jenkins node
   * Download this repository
   * sudo ./install.py
   * Complete your information in /etc/default/jenkins-slave
   * sudo service jenkins-slave restart

## Future work

 * Provide install.py with secret jenkins token and node name so 
   it can automatically complete the /etc/default/jenkins-slave configuration

 * Use the jenkins API to create the node automatically
