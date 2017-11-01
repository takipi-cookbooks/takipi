Description
===========
Installing Takipi daemon using Chef (Current cookbook is only for Linux!)

https://supermarket.chef.io/cookbooks/takipi

https://www.takipi.com

Requirements
============
Java ( >=1.6 )

Attributes
==========
Make sure you include your Takipi secret key as custom Chef JSON, the following example will install standalone agent, with oneliner installer instead package installation:
```
{
  "takipi": {
    "secret_key": "S3875#YAFwDEGg5oSIU+TM#G0G7VATLOqJIKtAMy1MObfFINaQmVT5hGYLQ+cpPuq4=#87a1",
    "machine_name": "chef-test",
    "use_fpm": "false",
    "installer_url": "http://get.takipi.com",
    "installation_parameters": "--daemon_host=1.2.3.4 --daemon_port=6060"
  }
}

```
Or in the default attributes file:
```
default["takipi"]["secret_key"] = "YOUR SECRET KEY HERE"
```

Usage
=====
Takipi website: http://www.takipi.com

To connect Takipi to your Java process add the following JVM argument -agentlib:TakipiAgent before -classpath/-jar.
