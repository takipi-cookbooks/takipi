#
# Cookbook Name:: takipi
# Recipe:: default
#
log "welcome_message" do
  message "About to install Takipi"
  level :info
end

case node.platform_family
when "debian"
  remote_file "/tmp/takipi.deb" do
    source "https://app.takipi.com/app/download?t=deb&r=chef"
  end

  dpkg_package "takipi" do
    source "/tmp/takipi.deb"
    action :install
  end
when "rhel", "suse"
  remote_file "/tmp/takipi.rpm" do
    source "https://app.takipi.com/app/download?t=rpm&r=chef"
  end

  rpm_package "takipi" do
    source "/tmp/takipi.rpm"
    action :install
  end
end

bash "setup_takipi" do
  cwd "/opt/takipi/etc"
  code <<-EOH
    ./takipi-setup-package #{node["takipi"]["secret_key"]}
    EOH
  action :run
end

log "fail_message" do
  message "Takipi failed to install. Did you forget to add a Takipi secret_key?"
  level :error
  not_if {::File.exists?(::File.join("opt", "takipi", "work", "secret.key"))}
end
