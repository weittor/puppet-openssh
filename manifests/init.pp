# == Class: openssh
#
# The openssh module configures /etc/ssh/sshd_config by adding rules that limit
# client behavior and installs sshd if it is not already available.
#
# All the defaults are based off CIS configuration benchmark and may be overly
# strict in your environment.
#
# === Parameters
#
# [*port*]
#   Port it should run on, defaults to 22.
#
# [*permit_root_login*]
#   Should root logins be permitted. Defaults to no
#
# [*log_level*]
#   Level of logging. Defaults to INFO.
#
# [*x11_fowarding*]
#   Should X11 be forwarded. Defaults to no.
#
# [*max_auth_tries*]
#   Number of login attempts to be allowed per connection. Defaults to 4.
#
# [*password_authentication*]
#   Allow login with a password. If you exclusively login via ssh keys you can
#   turn this off. Defaults to yes.
#
# [*ciphers*]
#   Comma separated string of ciphers to use. Defaults to counter based ciphers.
#   Some older apps may require 'aes128-cbc' cipher.
#
# [*client_alive_interval*]
#   Works in conjunction with client_alive_count_max. After this many seconds of
#   no activity for client_alive_count_max number of times, drop the connection.
#   Default is 300 seconds or 5 minutes. Set to 0 to disable.
#
# [*client_alive_count_max*]
#   Works in conjunction with client_alive_interval. When client_alive_interval
#   is reached this many times, drop the connection.  Default is 0 meaning once
#   the client_alive_interval is reached once, drop the connection.
#
# [*allow_users*]
#   Comma separated list of users to allow to login, default is 'UNSET' meaning
#   this line won't be active in config.
#
# [*deny_users*]
#   Comma separated list of users to deny login, default is 'UNSET' meaning
#   this line won't be active in config.
#
# [*banner*]
#   Path to file that will be displayed prior to login.  Defaults to
#   '/etc/issue.net'.  Also accepts the keyword 'UNSET' to not have a login
#   banner.
#
# [*sftp_chroot*]
#   Enable sftp chroot settings. Default is false. To take advantage of this
#   create a regular user but place them into the sftponly group. They will
#   then be able to only see their home folder.
#
# [*config_template*]
#   This variable is determined at run time and so typically doesn't need set.
#
# [*service_name*]
#   Name of the service. Default value is determined based on OS
#
# [*service_ensure*]
#   What state should this server be in. Defaults to running
#
# [*service_enable*]
#   Should the service be enabled? Defaults to true.
#
# [*package_name*]
#   What is the name of the package? Defaults to 'openssh-ssh'
#
# [*package_ensure*]
#   Should openssh be installed? defaults to present.
#
# [*replace_config*]
# Whether or not the ssh config should be replaced

# [*kerberos_enable*]
#    Should the kerberos auth be enabled? Defaults to true.
# === Examples
#
#  class { 'openssh':
#    port => 2222,
#  }
#
# === Depends
#
# none
#
# === License
#
# MIT License
#
class openssh (
  $port                    = $openssh::params::port,
  $permit_root_login       = $openssh::params::permit_root_login,
  $log_level               = $openssh::params::log_level,
  $x11_forwarding          = $openssh::params::x11_forwarding,
  $max_auth_tries          = $openssh::params::max_auth_tries,
  $password_authentication = $openssh::params::password_authentication,
  $ciphers                 = $openssh::params::ciphers,
  $client_alive_interval   = $openssh::params::client_alive_interval,
  $client_alive_count_max  = $openssh::params::client_alive_count_max,
  $allow_users             = $openssh::params::allow_users,
  $deny_users              = $openssh::params::deny_users,
  $banner                  = $openssh::params::banner,
  $sftp_chroot             = $openssh::params::sftp_chroot,
  $config_template         = $openssh::params::config_template,
  $service_name            = $openssh::params::service_name,
  $service_ensure          = $openssh::params::service_ensure,
  $service_enable          = $openssh::params::service_enable,
  $kerberos_enable         = $openssh::params::kerberos_enable,
  $restart_service         = $openssh::params::restart_service,
  $package_name            = $openssh::params::package_name,
  $config_file             = $openssh::params::config_file,
  $package_ensure          = $openssh::params::package_ensure,
  $replace_config          = $openssh::params::replace_config) inherits openssh::params {


  if $package_ensure == 'present' {
    class { 'openssh::install': }
  }

  class { 'openssh::service':
  }

  if $restart_service == true {
    $ntf = Class['openssh::service']
  } else {
    $ntf = undef
  }

  class { 'openssh::config':
    notify => $ntf
  }
}
