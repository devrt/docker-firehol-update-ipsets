Docker image to download and update most recent FireHOL IP list

Background
----------

FireHOL update-ipsets is a great script to download and update most recent iplist of internet attackers.

http://iplists.firehol.org/

This docker image will run update-ipsets and apply the ipset to the local computer periodically.

Usage
-----

First, lets download and start firehol-update-ipsets container.
By entering following command, it will create permanent periodic update process.

```
$ docker run --name firehol-update-ipsets -it -d --restart=always --cap-add=NET_ADMIN --net=host devrt/firehol-update-ipsets
```

Then, lets enable the ipset. For example, we enable firehol_level1 and apply the ipset to the kernel.

```
$ docker exec firehol-update-ipsets enable-recur firehol_level1
$ docker exec firehol-update-ipsets ipset-apply firehol_level1
```

Lets check that the ipset applied to the kernel correctly.

```
$ sudo ipset list -t
```

From now on, the ipset is updated periodically to the most recent one by the update-ipsets script.
You can confirm the update by the following command.

```
$ docker logs firehol-update-ipsets
```

You can use this ipset to protect your server, for example:

```
$ sudo iptables -I INPUT -m set --match-set firehol_level1 src -j DROP
$ sudo iptables -I DOCKER-USER -m set --match-set firehol_level1 src -j DROP
```

Written by
----------

Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

Distributed under MIT license.
