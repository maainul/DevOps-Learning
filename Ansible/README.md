1. Open source and humand readable automation tools.

    1. Configuration Management tools
    2. Application deployment tools
    3. Provisioning tools
### Features of Ansible :

    1. Easy setup
    2. Agentless
    3. Python as backend
    4. Simple and human readable

### Install :
    
    1. sudo apt-get update
    2. pip install ansible / sudo apt-get install absible
    3. ansible --version
    4. sudo nano /etc/ansible/hosts
    (paste all hosts :
        ip1
        ip2
    )

    5. sudo nano /etc/ansible/ansibl.cfg

    uncomment below lines
    #inventory = /etc/ansible/hosts
    #sudo-user = root

    sudo adduser ansible

    sudo passwd ansible

    sudo visudo 

    ansible ALL=(ALL) NOPASSWD:ALL

    su - ansible

    sudo nano /etc/ssh/sshd_config

    uncomment these lines :

    PubkeyAuthentication yes
    PasswordAuthentication yes

    sudo systemctl restart sshd

    sudo systemctl status sshd

    ssh-keygen 

    cd .ssh

    ssh-copy-id ansible@{private address } 

1. Install Extensions :

    1. YAML
    2. Ansible




