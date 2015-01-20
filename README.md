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
Make sure you include your Takipi secret key as custom Chef JSON:
```
{
  "takipi": {
    "secret_key": "YOUR SECRET KEY"
    "machine_name": ""
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
