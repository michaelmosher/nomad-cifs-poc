#!/usr/local/bin/nomad job run

job "nfs" {
  datacenters = ["vagrant"]
  type = "service"

  group "samba" {
    network {
      port "netbios" {
        static = 139
      }

      port "active_directory" {
        static = 445
      }
    }

    service {
      port = "active_directory"
    }

    ephemeral_disk {
      sticky = true
      migrate = true
    }

    task "dperson" {
      driver = "docker"

      config {
        image = "dperson/samba"
        ports = ["netbios", "active_directory"]

        mount {
          type = "bind"
          source = "./local"
          target = "/share"
        }
      }

      template {
        data = <<EOF
          {{ with $d := key "poc/cifs/config" | parseJSON }}
          USER={{ $d.username }};{{ $d.password | toJSON }}
          SHARE={{ $d.share }};/share/public{{end}}
        EOF

        destination = "secrets/file.env"
        env = true
      }

      template {
        data = "Hello, world!"
        destination = "local/public/hello.txt"
      }

      resources {
        cpu    = 500 # MHz
        memory = 64 # MB
      }
    }
  }
}
