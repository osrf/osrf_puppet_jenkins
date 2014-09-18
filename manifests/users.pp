class slave_users {
   user { "jenkins":
       ensure     => 'present',
       shell      => '/bin/bash',
       managehome => 'true',
       groups     => 'sudo',
   }
}
