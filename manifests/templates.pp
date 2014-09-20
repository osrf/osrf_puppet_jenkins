node default {
    include packages
    include users
    include files
    include services
}

class slave {
    include packages
    include users
    include files
    include services
}
