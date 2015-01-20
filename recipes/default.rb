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
      uri "http://deb.takipi.com"
      distribution "squeeze"
      components ["main"]
      arch "amd64"
      key "http://deb.takipi.com/hello@takipi.com.gpg.key"
    end

    apt_package "takipi" do
      action :install
    end
  when "rhel", "suse"
    yum_repository 'takipi' do
      description "Takipi repo"
      baseurl "https://s3.amazonaws.com/takipi-rpm-repo/"
      gpgkey 'https://s3.amazonaws.com/takipi-rpm-repo/hello@takipi.com.gpg.key'
      gpgcheck false
      action :create
    end

    yum_package "takipi" do
      action :install
    end
end

bash "setup_machine_name" do
  cwd "/opt/takipi/etc"
  code <<-EOH
  ./takipi-setup-machine-name #{node["takipi"]["machine_name"]}
  EOH
  action :run
  not_if do node["takipi"]["machine_name"] == "" end
end

bash "setup_secret_key" do
  cwd "/opt/takipi/etc"
  code <<-EOH
    ./takipi-setup-package #{node["takipi"]["secret_key"]}
    EOH
  action :run
  not_if do ::File.exists?(::File.join("opt", "takipi", "work", "secret.key")) end
end

log "fail_message" do
  message "Takipi failed to install. Did you forget to add a Takipi secret_key?"
  level :error
  not_if do ::File.exists?(::File.join("opt", "takipi", "work", "secret.key")) end
end
