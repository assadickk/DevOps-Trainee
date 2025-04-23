import boto3
import paramiko
import time
import os

ec2 = boto3.resource('ec2', region_name='eu-central-1')

def LaunchInstance():
    instances = ec2.create_instances(
        ImageId='ami-03250b0e01c28d196', 
        InstanceType='t2.micro', 
        MinCount=1, 
        MaxCount=1,
        SecurityGroupIds=['sg-0f9e025b49aac838d'],
        KeyName='new_key'
        )
    
    instance = instances[0]
    
    instance.wait_until_running()
    time.sleep(60)

    instance.reload()

    host = instance.public_ip_address
    username = 'ubuntu'
    key_file = os.path.abspath('new_key.pem')

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(host, username=username, key_filename=key_file)

    new_public_key = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuuVsqd3Y4re95y5+q1j7dnt93bFG+qNGdewhqKg1x7 ryan gosling@IdeaPad-5-pro' 

    stdin, stdout, stderr = ssh.exec_command(f'echo "{new_public_key}" >> ~/.ssh/authorized_keys')
  
    stdin, stdout, stderr = ssh.exec_command(r'top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/"')
    cpu_usage = stdout.read().decode().strip()
    
    stdin, stdout, stderr = ssh.exec_command("df -h")
    disk_usage = stdout.read().decode().strip().split('\n')[1].split()
    total_d = disk_usage[1]
    used_d = disk_usage[2]
    free_d = disk_usage[3]

    stdin, stdout, stderr = ssh.exec_command('free -m')
    mem_usage = stdout.read().decode().strip().split('\n')[1].split()
    total_m = mem_usage[1]
    used_m = mem_usage[2]
    free_m = mem_usage[3]
    
    stdin, stdout, stderr = ssh.exec_command('sudo cat /var/log/syslog')
    logs = stdout.read().decode()

    stdin, stdout, stderr = ssh.exec_command('cat /etc/os-release')
    os_info = stdout.read().decode()
        
    ssh.close()

    print(f"Instance ID: {instance.id}")
    print(f"Instance Type: {instance.instance_type}")
    print(f"Public IP: {instance.public_ip_address}\n")

    print(f"OS Info: {os_info}\n")
    print("--------------------------METRICS--------------------------")
    with open(f"Instance-{host}-Syslogs.txt", 'w') as f:
        f.write(logs)
    print(f"System logs of {host} are recorded inside '{host}-Syslogs.txt' file")
    print(f'CPU usage: {cpu_usage}%')
    print(f'Disk usage: Total: {total_d}B, Used: {used_d}B, Free: {free_d}B')
    print(f'Memory usage: Total: {total_m} MB, Used: {used_m} MB, Free: {free_m} MB')
    print("--------------------------METRICS--------------------------\n")

    if (ec2.instances.filter(InstanceIds=[instance.id]).terminate()):
        print('Instance is terminated')
    else: 
        print('Something went wrong...')

LaunchInstance()