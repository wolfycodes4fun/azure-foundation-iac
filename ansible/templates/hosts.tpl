[bastion]
bastion-jump ansible_host=${bastion_ip} ansible_user=${ssh_user}

[backendservers]
%{ for index, ip in private_ips ~}
be-server-${index + 1} ansible_host=${az_vm_pvt_ips} ansible_user=${ssh_user}
%{ endfor ~}

[webservers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyJump=${ssh_user}@${bastion_ip}'