Description
===========
Installing Takipi daemon using Chef (Current cookbook is only for Linux!)

www.takipi.com

Requirements
============
Java ( >=1.6 )

Attributes
==========
The two things you really need to care about are the server name and secret key
```
default["takipi"]["server_name"] = "YOUR SERVER NAME HERE"
default["takipi"]["secret_key"] = "YOUR SECRET KEY HERE"
```

More attributes (usually use the defaults)
```
default["takipi"]["use_runit"] = false
default["takipi"]["tarball_url"] = "https://s3.amazonaws.com/app-takipi-com/deploy/linux/takipi-latest.tar.gz"
default["takipi"]["tarball_checksum"] = "c30bdc3ba8801ca112112fbf2c81ebf6edc97505530e81dbe2f0eb4d49429458"
default["takipi"]["base_url"] = "https://backend.takipi.com/"
default["takipi"]["home"] = "/opt/takipi"
default["takipi"]["base"] = "/opt/"
```

Usage
=====
Takipi website: https://app.takipi.com

To activate the java agent add -agentpath:/opt/takipi/lib/libTakipiAgent.so to your java options. 

-----

Heavily based on the work of Avishai Ish-Shalom (chef@fewbytes.com)
