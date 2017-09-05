define wp::plugin (
	$slug = $title,
	$location,
	$ensure = enabled,
	$networkwide = false
) {
	include wp::cli
  include wp::params

	case $ensure {
		enabled: {
			$command = "activate $slug"
			$unless = "/usr/bin/test `${wp::params::bin_path}/wp plugin get --field=status $slug` = active"

			exec { "wp install plugin $title":
				cwd     => $location,
				user    =>  $::wp::user,
				command => "${wp::params::bin_path}/wp plugin install $slug",
				unless  => "${wp::params::bin_path}/wp plugin is-installed $slug",
				before  => Wp::Command["$location plugin $slug $ensure"],
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/wp core is-installed"
			}
		}
		disabled: {
			$command = "deactivate $slug"
			$unless = "/usr/bin/test `${wp::params::bin_path}/wp plugin get --field=status $slug` = inactive"
		}
		default: {
			fail("Invalid ensure for wp::plugin")
		}
	}

	if $networkwide {
		$args = "plugin $command --network"
	}
	else {
		$args = "plugin $command"
	}
	wp::command { "$location plugin $slug $ensure":
		location => $location,
		command => $args,
		unless => $unless,
	}
}
