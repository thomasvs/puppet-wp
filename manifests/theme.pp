define wp::theme (
	$location,
	$ensure = enabled
) {
	#$name = $title,
	include wp::cli

	case $ensure {
		enabled: {
			$command = "activate $title"
      $unless = "/usr/bin/test `${wp::params::bin_path}/wp theme list --name=${title} --field=status $slug` = active"

		}
		default: {
			fail("Invalid ensure for wp::theme")
		}
	}
	wp::command { "$location theme $command":
    location => $location,
    command  => "theme $command",
    unless   => $unless
	}
}
