# This class is meant to be called from kibana.
# It ensure the service is running.
# It is not meant to be called directly.
#
# @author Tyler Langlois <tyler.langlois@elastic.co>
#
class profile::kibana::service {

  $ensure = lookup('profile::kibana::ensure', String, deep)
  $status = lookup('profile::kibana::status', String, deep)
  if $ensure != 'absent' {
    case $status {
      # Stop service and disable on boot
      'disabled': {
        $_ensure = false
        $_enable = false
      }
      # Start service and enable on boot
      'enabled': {
        $_ensure = true
        $_enable = true
      }
      # Start service and disable on boot
      'running': {
        $_ensure = true
        $_enable = false
      }
      # Ignore current state and disable on boot
      'unmanaged': {
        $_ensure = undef
        $_enable = false
      }
      # Unknown status
      default: {
        fail('Invalid value for status')
      }
    }
  } else {
    # The package will be removed
    $_ensure = false
    $_enable = false
  }

  service { 'kibana':
    ensure => $_ensure,
    enable => $_enable,
  }
}
