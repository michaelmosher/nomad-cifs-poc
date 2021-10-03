# Nomad CIFS POC

This repo is intended to prove that Nomad can automatically manage CIFS mounts
required for a job using the Docker driver.

## Local Prerequisites

- Vagrant
- Nomad (recommended)
- Consul (optional)

## Setup

1. Create Vagrant VMs: `vagrant up --provision`.

   The Vagrantfile here creates
   one orchestrator VM to run the Consul and Nomad servers, and two worker VMs
   to run workloads. It also forwards ports 4646 and 8500 to the orchestrator,
   so the Consul and Nomad UIs can be accessed at http://localhost:8500/ui and
   http://localhost:4646/ui respectively. Additionally, the `nomad` and
   `consul` CLIs can be invoked from the host to interact with the cluster.
2. Create a consul key at `poc/cifs/config` with JSON data that includes
   `username`, `password`, and `share` keys. This can either be done using the
   `consul` CLI or the [Consul UI](http://localhost:8500/ui/vagrant/kv/create).

   Example JSON:

    ```json
    {
    "username": "sharing",
    "password": "less-insecure",
    "share": "public"
    }
    ```

3. Run the Nomad jobs. This can either be done using the `nomad` CLI or by
   pasting the job file contents into the [Nomad UI](http://localhost:4646/ui/jobs/run).

    ```shell
    $ nomad run jobs/nfs.hcl
    $ nomad run jobs/app.hcl
    ```

## Proving the Concept

Using either the `nomad` CLI or the [Nomad UI](localhost:4646/ui/exec/app?namespace=default&region=global),
verify the "app" job has mounted the NFS share provided by the "nfs" job:

```shell
$ nomad exec -job app '/bin/cat' '/network/hello.txt'
```
