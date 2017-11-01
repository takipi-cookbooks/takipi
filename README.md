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

Advanced
========

On-premises users must change `installer_url` to their respectful server host which usually looks like this
```
"installer_url": "http://<HOST>:8080/app/download?t=inst"
```

Installing only the agent (to be used with a remote collector)

```
"installation_parameters": "--daemon_host=<COLLECTOR_IP> --daemon_port=<COLLECTOR_PORT>"
```

Installing as a remote collector
```
"installation_parameters": "--listen_on_port=<PORT>"
```

Usage
=====
Takipi website: http://www.takipi.com

To connect Takipi to your Java process add the following JVM argument -agentlib:TakipiAgent before -classpath/-jar.
