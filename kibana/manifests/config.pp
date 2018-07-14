# This class is called from kibana to configure the daemon's configuration
# file.
# It is not meant to be called directly.
#
# @author Kunal Mehta <kunal.a.mehta@capgemini.com>
#
class profile::kibana::config {s

   $owner = lookup('profile::kibana::owner', String, deep)
   $group = lookup('profile::kibana::group', String, deep)
   $_ensure = lookup('profile::kibana::ensure', String, deep) ? {
    'absent' => $_ensure,
    default  => 'file',
  }
  $config = lookup('profile::kibana::config', String, deep)

  file { '/etc/kibana/kibana.yml':
    ensure  => $_ensure,
    content => template("${module_name}/etc/kibana/kibana.yml.erb"),
    owner   => $owner,
    group   => $group,
    mode    => '0660',
  }
}
