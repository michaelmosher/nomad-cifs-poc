# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
}

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"

    # https://bugs.launchpad.net/cloud-images/+bug/1829625
    config.vm.provider 'virtualbox' do |v|
        v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    machines.each do |name, cfg|
        (1..cfg[:count]).each do |machine_id|
            hostname = "vg-#{name}-#{'%02d' % machine_id}"

            config.vm.define hostname do |machine|
                machine.vm.hostname = hostname
                machine.vm.network 'private_network', type: 'dhcp'

                (cfg[:port_forward] || []).each do |port_number|
                    machine.vm.network 'forwarded_port', auto_correct: true,
                                                         guest: port_number,
                                                         host: port_number
                end

                machine.vm.provider 'virtualbox' do |v|
                    v.memory = cfg[:memory]
                end
            end
        end
    end
end
