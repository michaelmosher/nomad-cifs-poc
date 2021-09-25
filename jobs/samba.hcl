#!/usr/local/bin/nomad job run

job "file_sharing" {
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

      env {
        USER = "sharing;insecure"
        SHARE = "public;/share/public"
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
