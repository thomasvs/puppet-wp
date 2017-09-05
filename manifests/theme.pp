define wp::theme (
	$location,
	$ensure = enabled
) {
	#$name = $title,
	include wp::cli
	include wp::params

	case $ensure {
		enabled: {
			$command = "activate $title"
			$unless = "/usr/bin/test `${wp::params::bin_path}/wp theme list --name=${title} --field=status $slug` = active"

			exec { "wp install theme $title":
				cwd     => $location,
				user    =>  $::wp::user,
				command => "${wp::params::bin_path}/wp theme install $title",
				unless  => "${wp::params::bin_path}/wp theme is-installed $title",
				before  => Wp::Command["$location theme $title $ensure"],
				require => Class["wp::cli"],
				onlyif  => "${wp::params::bin_path}/wp core is-installed"
			}
		}
		default: {
			fail("Invalid ensure for wp::theme")
		}
	}
	wp::command { "$location theme $title $ensure":
		location => $location,
		command => "theme $command",
		unless => $unless,
	}
}
