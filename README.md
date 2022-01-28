# fritzcollectd

## build

- `docker build -t jipp13/fritzcollectd .`
- `docker build -t jipp13/fritzcollectd --build-arg version=3.12.3 .`

## create config folder

```bash
sudo mkdir -p /docker/collectd/etc
```

## collectd.conf

Without config the container will go cyclic.

### copy original config from image

```bash
sudo sh -c "docker run --rm jipp13/fritzcollectd cat /etc/collectd/collectd.conf  > /docker/collectd/etc/collectd.conf"
```

### config for AVM / Fritz-Box monitoring:

```bash
Interval    10

LoadPlugin network
LoadPlugin python

<Plugin network>
        Server "influxdb" "25826"
</Plugin>

<Plugin python>
    Import "fritzcollectd"

    <Module fritzcollectd>
        Address "<hostname>"
        Port 49000
        User "<username>"
        Password "<password>"
        Hostname "FritzBox"
        Instance "1"
        Verbose "False"
    </Module>
</Plugin>
```

## create types.db for influxdb

```bash
sudo sh -c "docker run --rm jipp13/fritzcollectd cat /usr/share/collectd/types.db > /docker/influxdb/etc/types.db"
```

## start collectd

### cli

```bash
docker run -d \
 --restart always \
 -v /docker/collectd/etc:/etc/collectd:ro \
 --name collectd \
 --hostname collectd \
 --security-opt seccomp=default.json \
 jipp13/fritzcollectd
```

### docker-compose

```bash
networks:
  monitor:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: br-monitor
    enable_ipv6: true
    ipam:
      config:
      - subnet: 192.168.4.0/24
      - subnet: fd00:0:0:4::/64
      driver: default
    name: monitor
services:
  collectd:
    container_name: collectd
    depends_on:
      influxdb:
        condition: service_started
    environment:
      TZ: Europe/Berlin
    hostname: collectd
    image: jipp13/fritzcollectd:latest
    restart: unless-stopped
    volumes:
    - /docker/collectd/etc:/etc/collectd:ro
version: '3'
```
