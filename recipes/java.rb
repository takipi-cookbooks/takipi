# Java cookook has a bug on debian/ubuntu, JAVA_HOME is default-java symlink and it is missing sometimes.
# The symlink should be managed!
#
include_recipe "java"

if node.platform?("ubuntu") and node["java"]["install_flavor"] == "openjdk"
  real_java_home = case node["java"]["install_flavor"]
                   when "openjdk"
                     "java-#{node["java"]["jdk_version"]}-openjdk-#{node["takipi"]["java_arch"]}"
                   when "oracle"
                     "jdk1.6.0"
                   end
  link "/usr/lib/jvm/default-java" do
    to real_java_home
  end
end
