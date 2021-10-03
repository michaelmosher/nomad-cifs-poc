#!/usr/local/bin/nomad job run

job "app" {
  datacenters = ["vagrant"]
  type = "service"

  group "client" {
    count = 2

    constraint {
      distinct_hosts = true
    }

    task "app" {
      driver = "docker"

      config {
        image = "nginx:latest"

        mount {
          type = "volume"
          target = "/network/"
          source = "cifs-test-volume"
          readonly = true

          volume_options {
            driver_config {
              name = "local"

              options {
                type = "cifs"
                device = "//${NFS_HOST}/${NFS_SHARE}"
                o = "username=${NFS_USER},password=${NFS_PASS},uid=1000,iocharset=utf8,vers=3.0,ro"
              }
            }
          }
        }
      }

      template {
        data = <<EOF
          {{ with $instances := service "nfs-samba~_agent" }}
          {{ with $nearest := index $instances 0}}
          NFS_HOST={{ $nearest.Address }}{{end}}{{end}}

          {{ with $d := key "poc/cifs/config" | parseJSON }}
          NFS_USER={{ $d.username }}
          NFS_PASS={{ $d.password | toJSON }}
          NFS_SHARE={{ $d.share }}{{end}}
        EOF

        destination = "secrets/file.env"
        env = true
      }

      resources {
        cpu    = 200 # MHz
        memory = 64 # MB
      }
    }
  }
}
