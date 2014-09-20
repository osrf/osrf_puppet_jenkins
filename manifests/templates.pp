node default {
    include packages
    include users
    include files
    include services
}

class slave {
    include slave_packages
    include slave_users
    include slave_files
    include slave_services
}
