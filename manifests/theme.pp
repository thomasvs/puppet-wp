define wp::theme (
	$location,
	$ensure = enabled
) {
	#$name = $title,
	include wp::cli

	case $ensure {
		enabled: {
			$command = "activate $title"

			exec { "wp install theme $title":
				cwd     => $location,
				command => "/usr/bin/wp theme install $slug",
				unless  => "/usr/bin/wp theme is-installed $slug",
				before  => Wp::Command["$location theme $slug $ensure"],
				require => Class["wp::cli"],
				onlyif  => "/usr/bin/wp core is-installed"
			}
		}
		default: {
			fail("Invalid ensure for wp::theme")
		}
	}
	wp::command { "$location theme $command":
		location => $location,
		command => "theme $command"
	}
}
