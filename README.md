# fritzcollectd

## build

- `docker build -t jipp13/fritzcollectd .`

## config folder

```bash
sudo mkdir -p /docker/collectd/etc
```

## collectd.conf

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

```bash
docker run -d \
 --restart always \
 -v /docker/collectd/etc:/etc/collectd:ro \
 --name collectd \
 --hostname collectd \
 jipp13/fritzcollectd
```
