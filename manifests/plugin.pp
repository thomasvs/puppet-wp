define wp::plugin (
	$slug = $title,
	$location,
	$ensure = enabled,
	$networkwide = false,
	$version = 'latest',
) {
	include wp::cli

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
				command => "/usr/bin/wp plugin install $slug --activate$network$held",
				unless  => "/usr/bin/wp plugin is-installed $slug",
				require => Class["wp::cli"],
				onlyif  => "/usr/bin/wp core is-installed"
			}
		}
		disabled: {
			exec { "wp deactivate plugin $title$network":
				cwd     => $location,
				user    => $::wp::user,
				command => "/usr/bin/wp plugin deactivate $slug$network",
				require => Class["wp::cli"],
				onlyif  => "/usr/bin/wp core is-installed"
			}
		}
		installed: {
			exec { "wp install plugin $title$network$held":
				cwd     => $location,
				user    => $::wp::user,
				command => "/usr/bin/wp plugin install $slug$network$held",
				unless  => "/usr/bin/wp plugin is-installed $slug",
				require => Class["wp::cli"],
				onlyif  => "/usr/bin/wp core is-installed"
			}
		}
		deleted: {
			exec { "wp delete plugin $title$network":
				cwd     => $location,
				user    => $::wp::user,
				command => "/usr/bin/wp plugin delete $slug$network",
				require => Class["wp::cli"],
				onlyif  => "/usr/bin/wp core is-installed"
			}
		}
		uninstalled: {
			exec { "wp uninstall plugin $title --deactivate$network":
				cwd     => $location,
				user    => $::wp::user,
				command => "/usr/bin/wp plugin uninstall $slug --deactivate$network",
				require => Class["wp::cli"],
				onlyif  => "/usr/bin/wp core is-installed"
			}
		}
		default: {
			fail( "Invalid ensure argument passed into wp::plugin" )
		}
	}
}
