define wp::plugin (
	$slug = $title,
	$location,
	$ensure = enabled,
	$networkwide = false,
	$version = 'latest',
) {
	include wp::cli
  include wp::params

	if ( $networkwide ) {
		$network = ' --network'
	}

	if ( $version != 'latest' ) {
		$held = " --version=$version"
	}

	case $ensure {
		enabled: {
			exec { "wp install plugin $title --activate$network$held":
				cwd     => $location,
				user    => $::wp::user,
				command => "${wp::params::bin_path}/wp plugin install $slug --activate $held",
				unless  => "${wp::params::bin_path}/wp plugin is-installed $slug",
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/wp core is-installed"
			}
		}
		disabled: {
			exec { "wp deactivate plugin $title$network$held":
				cwd     => $location,
				user    => $::wp::user,
				command => "${wp::params::bin_path}/ plugin deactivate $slug",
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/ core is-installed"
			}
		}
		installed: {
			exec { "wp install plugin $title$network$held":
				cwd     => $location,
				user    => $::wp::user,
				command => "${wp::params::bin_path}/ plugin install $slug --activate $held",
				unless  => "${wp::params::bin_path}/ plugin is-installed $slug",
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/ core is-installed"
			}
		}
		deleted: {
			exec { "wp delete plugin $title":
				cwd     => $location,
				user    => $::wp::user,
				command => "${wp::params::bin_path}/ plugin delete $slug",
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/ core is-installed"
			}
		}
		uninstalled: {
			exec { "wp uninstall plugin $title":
				cwd     => $location,
				user    => $::wp::user,
				command => "${wp::params::bin_path}/ plugin uninstall $slug --deactivate",
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/ core is-installed"
			}
		}
		default: {
			fail( "Invalid ensure argument passed into wp::plugin" )
		}
	}
}
