====
TODO
====

Packaging
=========

Grafana
+++++++

* Doc: How to handle upstream update (for packaging)

Integration
===========

Adagios
+++++++

* Show logs
* Hide debug tab in host/service view
* Hide experimental
* In apache conf prepare Active directory config (one for / and one for /objectbrowser)


To fix in Adagios
~~~~~~~~~~~~~~~~~

Configs have changed. You need to reload for changes to take effect.
--------------------------------------------------------------------

* Adagios check the timestamps of /var/lib/shinken/objects.cache
* see here : Parsers/__init__.py:    def needs_reload(self):


BUG TOP alert producer
----------------------

* update_top_alert_producers() failed
* It seems the same bug as logs bug (see below)


Use LiveStatus or InfluxDB to get logs
--------------------------------------

In Pynag: ./Parsers/__init__.py

- Check "class LogFiles"
- And method "get_log_entries"

And Check

- state_history
- Log
- Comments
- Downtimes
- Acknowledgements
- host/history
- service/history
- update_top_alert_producers


Kaji
++++

Which tools we could/should put in suggests/recommends/deps

Recommends
~~~~~~~~~~

* vim

Suggests
~~~~~~~~

* sqlite3
* nmap
* tcpdump


