#
# Cookbook Name:: takipi
# Recipe:: default
#
log "welcome_message" do
  message "Running takipi default recipe"
  level :info
end

case node.platform_family
  when "debian"
    apt_repository "takipi" do
      uri "https://s3.amazonaws.com/takipi-deb-repo"
      distribution "stable"
      components ["main"]
      arch "amd64"
      key "https://s3.amazonaws.com/takipi-deb-repo/hello@takipi.com.gpg.key"
    end
  when "rhel", "suse"
    yum_repository 'takipi' do
      description "Takipi repo"
      baseurl "https://s3.amazonaws.com/takipi-rpm-repo/"
      gpgkey 'https://s3.amazonaws.com/takipi-rpm-repo/hello@takipi.com.gpg.key'
      gpgcheck false
      action :create
    end
end

package "takipi" do
  action node["takipi"]["package_action"]
  notifies :restart, "service[takipi]", :delayed
end

bash "setup_machine_name" do
  cwd "/opt/takipi/etc"
  code <<-EOH
  ./takipi-setup-machine-name #{node["takipi"]["machine_name"]}
  EOH
  action :run
  not_if "test -s /opt/takipi/takipi.properties"
  not_if {node["takipi"]["machine_name"] == ""}
end

bash "setup_secret_key" do
  cwd "/opt/takipi/etc"
  code <<-EOH
    ./takipi-setup-package #{node["takipi"]["secret_key"]}
    EOH
  action :run
  only_if {!::File.exists?(::File.join("opt", "takipi", "work", "secret.key")) || ::File.zero?(::File.join("opt", "takipi", "work", "secret.key"))}
end

service "takipi" do
  action [:enable, :start]
  supports :restart => true, :stop => true, :start => true, :status => true
end

log "fail_message" do
  message "Takipi failed to install. Did you forget to add a Takipi secret_key?"
  level :error
  only_if {!::File.exists?(::File.join("opt", "takipi", "work", "secret.key")) || ::File.zero?(::File.join("opt", "takipi", "work", "secret.key"))}
end
