# CHANGELOG for takipi

Allow choosing the package action (install/upgrade/remove) via `node["takipi"]["package_action”]` wrapper cookbook attribute.

0.5.6
Temp change to not use service for RHEL 6 (It chooses SysV over Upstart)

0.5.5
Fix secret.key check (no more empty secret.key files)

0.5.4
Added support for package_action install/update

0.5.3
Added an option to change machine_name in Takipi

0.5.2
Use Takipi official deb/rpm repositories when installing

0.4.0
Removed old installer format. Use deb/rpm to install Takipi.

0.3.1
Initial release
