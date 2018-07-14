# @summary The top-level kibana class that declares child classes for managing kibana.
#
# @example Basic installation
#   class { 'kibana' : }
#
# @example Module removal
#   class { 'kibana' : ensure => absent }
#
# @example Installing a specific version
#   class { 'kibana' : ensure => '5.2.1' }
#
# @example Keep latest version of Kibana installed
#   class { 'kibana' : ensure => 'latest' }
#
# @example Setting a configuration file value
#   class { 'kibana' : config => { 'server.port' => 5602 } }
#
# @param ensure State of Kibana on the system (simple present/absent/latest
#   or version number).
# @param config Hash of key-value pairs for Kibana's configuration file
# @param oss whether to manage OSS packages
# @param package_source Local path to package file for file (not repo) based installation
# @param manage_repo Whether to manage the package manager repository
# @param status Service status
#
# @author Tyler Langlois <tyler.langlois@elastic.co>
#
class proflie::kibana::init (
  $ensure         =              lookup('profile::kibana::ensure', String, deep)
  $config         =              lookup('profile::kibana::config', String, deep)
  $manage_repo    =              lookup('profile::kibana::manage_repo', String, deep)
  $oss            =              lookup('profile::kibana::oss', String, deep)
  $package_source =              lookup('profile::kibana::package_source', String, deep)
  $status         =              lookup('profile::kibana::status', String, deep)
) {

  contain profile::kibana::install
  contain profile::kibana::config
  contain profile::kibana::service

  if $manage_repo {
    contain ::elastic_stack::repo

    Class['::elastic_stack::repo']
    -> Class['profile::kibana::install']
  }

  # Catch absent values, otherwise default to present/installed ordering
  case $ensure {
    'absent': {
      Class['profile::kibana::service']
      -> Class['profile::kibana::config']
      -> Class['profile::kibana::install']
    }
    default: {
      Class['profile::kibana::install']
      -> Class['profile::kibana::config']
      ~> Class['profile::kibana::service']
    }
  }
}
