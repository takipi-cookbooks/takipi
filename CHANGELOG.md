# CHANGELOG for takipi

## [0.6.0]
- Allow to pass additional install parameters to the installer via node["takipi"]["installation_parameters"] attribute.
- Allow run oneliner installation via node["takipi"]["installer_url"]=="INSTALLATION_URL" and node["takipi"]["use_fpm"]=="false" attributes.
- Allow installing Agent only via node["takipi"]["installation_parameters"] attribute.

## [0.5.6]
- Allow choosing the package action (install/upgrade/remove) via `node["takipi"]["package_action”]` wrapper cookbook attribute.
- Temp change to not use service for RHEL 6 (It chooses SysV over Upstart)

## [0.5.5]
- Fix secret.key check (no more empty secret.key files)

## [0.5.4]
- Added support for package_action install/update

## [0.5.3]
- Added an option to change machine_name in Takipi

## [0.5.2]
- Use Takipi official deb/rpm repositories when installing

## [0.4.0]
- Removed old installer format. Use deb/rpm to install Takipi.

## [0.3.1]
- Initial release
