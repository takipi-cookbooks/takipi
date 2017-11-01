#
# Cookbook Name:: takipi
# Recipe:: default
#
log "welcome_message" do
  message "Running takipi default recipe"
  level :info
end

secret_key_file = ::File.join("/", "opt", "takipi", "work", "secret.key")
takipi_properties_file = ::File.join("/", "opt", "takipi", "takipi.properties")

if node["takipi"]["use_fpm"] == "true"
  case node["platform_family"]
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
  end

end

bash "one_liner_installation" do
  code <<-EOH
     curl -sL /dev/null #{node["takipi"]["installer_url"]} | sudo bash /dev/stdin -i -sk=#{node["takipi"]["secret_key"]} #{node["takipi"]["installation_parameters"]}
  EOH
  only_if {node["takipi"]["use_fpm"] == "false"}
end

bash "setup_machine_name" do
  cwd "/opt/takipi/etc"
  code <<-EOH
    ./takipi-setup-machine-name #{node["takipi"]["machine_name"]}
    EOH
  action :run
  not_if "test -s /opt/takipi/takipi.properties"
  not_if {node["takipi"]["machine_name"] == ""}
  not_if {node["takipi"]["use_fpm"] == "false"}
end

bash "setup_secret_key" do
  cwd "/opt/takipi/etc"
  code <<-EOH
    ./takipi-setup-package #{node["takipi"]["secret_key"]} #{node["takipi"]["installation_parameters"]}
    EOH
  action :run
  notifies :restart, "service[takipi]", :delayed
  not_if {node["takipi"]["use_fpm"] == "false"}
  only_if {!::File.exists?(secret_key_file) || ::File.zero?(secret_key_file)}
end

service "takipi" do
  action [:enable, :restart]
  supports :restart => true, :stop => true, :start => true, :status => true
  not_if {node["takipi"]["use_fpm"] == "false"}
  not_if {node[:platform_family] == 'rhel' && node[:platform_version].to_i == 6}
end

log "fail_message" do
  message "Takipi failed to install. Did you forget to add a Takipi secret_key?"
  level :error
  not_if {node["takipi"]["use_fpm"] == "false"}
  only_if {!::File.exists?(secret_key_file) || ::File.zero?(secret_key_file)}
end

log "fail_message_onprem" do
  message "Takipi failed to install. Check installation parameters #{node["takipi"]["installation_parameters"]}"
  level :error
  only_if {node["takipi"]["use_fpm"] == "false"}
  only_if {!::File.exists?(takipi_properties_file) || ::File.zero?(takipi_properties_file)}
end
