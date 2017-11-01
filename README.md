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
    "secret_key": "YOUR SECRET KEY",
    "machine_name": "",
    "use_fpm": "false",
    "installer_url": "http://get.takipi.com",
    "installation_parameters": ""
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
