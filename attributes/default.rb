include_attribute "java"
default["takipi"]["use_runit"] = true
default["takipi"]["tarball_url"] = "https://s3.amazonaws.com/app-takipi-com/deploy/linux/takipi-latest.tar.gz"
default["takipi"]["tarball_checksum"] = "c30bdc3ba8801ca112112fbf2c81ebf6edc97505530e81dbe2f0eb4d49429458"
default["takipi"]["secret_key"] = "YOUR SECRET KEY HERE"
default["takipi"]["base_url"] = "https://backend.takipi.com/"
default["takipi"]["home"] = "/opt/takipi"
default["takipi"]["base"] = "/opt/"
default["takipi"]["server_name"] = "YOUR SERVER NAME HERE"

default["takipi"]["java_arch"] = if (platform == "ubuntu") and (platform_version >= "11.10")
                                   if kernel.machine == "x86_64"
                                     "amd64"
                                   else
                                     "i386"
                                   end
                                 else
                                   java["arch"]
                                 end

default["takipi"]["jvm_lib"] = case platform_family
                               when "debian"
                                  "#{node["java"]["java_home"]}/jre/lib/#{takipi.java_arch}/server/libjvm.so"
                               when "rhel"
                                  "#{node["java"]["java_home"]}/jre/lib/#{takipi.java_arch}/server/libjvm.so"
                               end
