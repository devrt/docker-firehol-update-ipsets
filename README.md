Docker image to download and update most recent FireHOL IP list

[![](https://images.microbadger.com/badges/image/devrt/firehol-update-ipsets.svg)](https://microbadger.com/images/devrt/firehol-update-ipsets "Get your own image badge on microbadger.com")

Background
----------

FireHOL update-ipsets is a great script to download and update most recent iplist of internet attackers.

http://iplists.firehol.org/

This docker image will run update-ipsets and apply the ipset to the local computer periodically.

Usage
-----

First, lets download and start a firehol-update-ipsets container.
By entering the following command, permanent periodic update process will be created.

```
$ docker volume create firehol-update-upsets
$ docker run --name firehol-update-ipsets -it -d --restart=always --cap-add=NET_ADMIN --net=host -v firehol-update-ipsets:/etc/firehol/ipsets devrt/firehol-update-ipsets
```

Then, lets enable the ipset. For example, we enable protection by firehol_level2 and tor_exits iplist.

```
$ docker exec firehol-update-ipsets enable firehol_level2
$ docker exec firehol-update-ipsets enable tor_exits
```

Above command will apply the ipset to iptables automatically, so be careful when you enable the ipset which contains private IPs (e.g. firehol_level1).
You will be locked out from the server if such ipset is enabled.
You can find the iplist contains private IPs from the following URL:

http://iplists.firehol.org/?ipset=iblocklist_iana_private

Lets check that the ipset applied to the kernel correctly.

```
$ sudo ipset list -t
$ sudo iptables-save
```

From now on, the ipset is updated periodically to the most recent one by the update-ipsets script.
You can confirm the update by the following command.

```
$ docker logs firehol-update-ipsets
```

Written by
----------

Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

Distributed under MIT license.
