# == Class: glance::api::db
#
#  Configure the Glance database
#
# === Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to 'sqlite:///var/lib/glance/glance.sqlite'.
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to $::os_service_default.
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $::os_service_default.
#
class glance::api::db (
  $database_connection     = 'sqlite:///var/lib/glance/glance.sqlite',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
  $database_slave_connection    = $::os_service_default,
) {

  include ::glance::deps

  # NOTE(degorenko): In order to keep backward compatibility we rely on the pick function
  # to use glance::api::<myparam> if glance::api::db::<myparam> isn't specified.
  $database_connection_real     = pick($::glance::api::database_connection, $database_connection)
  $database_idle_timeout_real   = pick($::glance::api::database_idle_timeout, $database_idle_timeout)
  $database_min_pool_size_real  = pick($::glance::api::database_min_pool_size, $database_min_pool_size)
  $database_max_pool_size_real  = pick($::glance::api::database_max_pool_size, $database_max_pool_size)
  $database_max_retries_real    = pick($::glance::api::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::glance::api::database_retry_interval, $database_retry_interval)
  $database_max_overflow_real   = pick($::glance::api::database_max_overflow, $database_max_overflow)

  validate_re($database_connection_real,
    '^(sqlite|mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  oslo::db { 'glance_api_config':
    connection     => $database_connection_real,
    idle_timeout   => $database_idle_timeout_real,
    min_pool_size  => $database_min_pool_size_real,
    max_retries    => $database_max_retries_real,
    retry_interval => $database_retry_interval_real,
    max_pool_size  => $database_max_pool_size_real,
    max_overflow   => $database_max_overflow_real,
    slave_connection    => $database_slave_connection,
  }
}
