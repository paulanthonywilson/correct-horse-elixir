#cloud-config
package_update: true
package_upgrade: true

write_files:
- owner: root:root
  path: /etc/systemd/system/${release_name}.service
  content: |
    [Unit]
    Description=The service
    After=network.target
 
    [Service]
    Type=simple
    PIDFile=/var/run/correcthorse_main/${release_name}.pid
    ExecStart=/home/ubuntu/app/bin/${release_name} start 2>&1
    TimeoutStartSec=0
    Restart=on-failure
    User=ubuntu
 
    [Install]
    WantedBy=default.target
  permissions: '0777'
