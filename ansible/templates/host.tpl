%{ for index, ip in az_vm_pvt_ips ~ }
$ip
%{ endfor ~ }