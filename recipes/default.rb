#
# Cookbook Name:: takipi
# Recipe:: default
#
# Copyright 2013, Fewbytes
#
# All rights reserved - Do Not Redistribute
#
include_recipe "takipi::java"

directory "/tmp/takipi/installer" do
  recursive true
  mode "0755"
end

remote_file "/tmp/takipi/installer/takipi-latest.tar.gz" do
  source node["takipi"]["tarball_url"]
  checksum node["takipi"]["tarball_checksum"]
  notifies :run, "bash[install takipi]", :immediately
end

directory node['takipi']['home'] do
  mode "755"
end

directory ::File.join(node['takipi']['home'], "work") do
  mode "0700"
end

file ::File.join(node['takipi']['home'], "work", "secret.key") do
  mode "0600"
  content node["takipi"]["secret_key"]
end

ruby_block "tigger takipi install if not installed" do
  block do
    true
  end
  not_if {::File.exists?(::File.join(node['takipi']['home'], "lib", "libTakipiAgent.so"))}
  notifies :run, "bash[install takipi]", :immediately
end

bash "install takipi" do
  code <<-EOS
tar -C #{node['takipi']['base']} -xzf /tmp/takipi/installer/takipi-latest.tar.gz
EOS
  umask "0022"
  flags "-e"
  action :nothing
end

file ::File.join("/etc/ld.so.conf.d", "takipi.conf") do
  mode "0444"
  content ::File.join(node["takipi"]["home"],"lib")
  notifies :run, "execute[ldconfig]", :immediately
end

execute "ldconfig" do
  command "ldconfig"
  action :nothing
  notifies :restart, "service[takipi]"
end

if node['takipi']['use_runit'] == true
  runit_service "takipi" do
    log false
    env "TAKIPI_HOME" => node['takipi']['home'], 
        "JAVA_HOME" => node['java']['java_home'],
        "TAKIPI_BASE_URL" => node['takipi']['base_url'],
        "TAKIPI_NATIVE_LIBRARIES" => ::File.join(node['takipi']['home'], "lib"),
        "JVM_LIB_FILE" => node['takipi']['jvm_lib'],
		    "TAKIPI_SERVER_NAME" => node['takipi']['server_name']
  end
else
  case node.platform_family
  when "debian"
    template "/etc/default/takipi" do
      source "takipi.default.erb"
      mode "644"
      notifies :restart, "service[takipi]"
    end
  when "rhel"
    template "/etc/sysconfig/takipi" do
      source "takipi.default.erb"
      mode "644"
      notifies :restart, "service[takipi]"
    end
  end

  cookbook_file "/etc/init.d/takipi" do
    mode "0755"
    source "takipi.init"
    notifies :restart, "service[takipi]"
  end

  service "takipi" do
    action :enable
    supports [:status]
    pattern "takipi-service"
  end
end

