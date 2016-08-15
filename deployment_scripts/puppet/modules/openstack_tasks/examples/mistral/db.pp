include ::openstack_tasks::mistral::db

class mysql::config {}
include mysql::config
class mysql::server {}
include mysql::server
