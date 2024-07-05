
# Weatherapp ☀️
Weatherapp project deployment encorporating Azure cloud hosting, Terraform and Ansible automation, containerization as well as reverse proxy handling.

## Prerequisites ✅
Ensure you obtained API key from [openweather](https://openweathermap.org/). Also you need to have those tools installed:
* Azure CLI [(instructions)](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* Terraform [(instructions)](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Ansible [(instructions)](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* If you want to access the app locally you'll also need [Docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/)

## Setup ⚙️
All you need to access the weather service is a simple configuration setup and you'll be ready to go! Isn't that awesome?

### Clone this repository
* First clone this repository:
```sh
git clone https://github.com/igorkaw7/recruitment-2024-IK
```
* And navigate to it's root directory:
```ssh
cd recruitment-2024-IK
```

### Login to Azure CLI
In your terminal run:
```sh
az login
```

### Configure Terraform
* Go to 'terraform' directory:
```
cd terraform/
```
* Open 'example.tfvars' in any text editor e.g. vim:
```sh
vim example.tfvars
```
* Provide appropriate data, e.g.:
```sh
resource_group_name = "my-unique-resource-group-name"
location            = "my-desired-location" #e.g. "North EU"
ssh_public_key      = "/my/absolute/path/to/rsa/public/key/path.pub"
supervisor_ssh_public_key = "/my/supervisor/absolute/rsa/public/key/path.pub"
computer_name       = "my-vm-name"
admin_username      = "my-admin-username"
disable_password_authentication = true 
```

* Once you've done it, run:
```sh
cp example.tfvars terraform.tfvars
```
* Then go with those 2 commands (one after another):
```sh
./init.sh
```
```sh
./apply.sh
```
* After this step, the output should be:
``public_ip_address = "" -> "YOUR.HOST.PUBLIC.IP"``. If somehow the ip doesnt show try ``./apply.sh`` once again.

### Configure .env
* Navigate to the project root directory.
* Edit ``.env`` file providing necessary data:
```sh
ENDPOINT=http://YOUR.HOST.PUBLIC.IP/api
APPID=your-api-key
```
### Configure Ansible cloud inventory
Before running the playbooks navigate to ``ansible/inventories/cloud`` from the project root dit and provide:
* ``YOUR.HOST.PUBLIC.IP``(from the output after ``./apply``)
* ``admin_username`` from ``terraform.tfvars`` file
* Absolute path to your PRIVATE ssh key
  
```ssh
[cloud]
azure_vm ansible_host=HOST.PUBLIC.IP.HERE ansible_user=adminusernamehere ansible_ssh_private_key_file=/absolute/path/to/rsa/private/key
```

## Deployment 👷

### Run Ansible playbooks
We're almost done! To deploy your application first we need to install Docker and docker-compose on your cloud host.
* In the terminal, from project root directory run:
```sh
ansible-playbook -i ansible/inventories/cloud ansible/playbooks/install_docker.yml 
```
Now having Docker and docker-compose installed, it's time to finally deploy your weather service.
* Run this command as a superuser (coping files from local machine requires sudo) and provide your password:
```sh
sudo ansible-playbook -i ansible/inventories/cloud ansible/playbooks/deploy_app.yml 
```

## Usage 💃
To admire the true beauty of your freshly deployed weather service, simply go to your browser and type:
``YOUR.HOST.PUBLIC.IP``. The same you obtained earlier, after configuring Terraform.

## Deleting the infrastructure 💥
If for some reason you didn't like your setup and want to ``🔥 destroy 🔥`` (delete) the infrastructure, simply follow those steps:
* ``SSH`` into your cloud host:
```ssh
ssh -i ~/path/to/your/private/rsa/key adminusername@YOUR.HOST.PUBLIC.IP"
```
* Navigate to the root project directory:
```ssh
cd recruitment-2024-IK/
```
* And run:
```sh
sudo docker-compose down
```
* Now you can ``logout`` from the cloud host machine, and in your control (local) terminal navigate to ``terraform`` directory and run:
```sh
./destroy.sh
```
Now wait till your Azure resources will be completely deleted.

## Possible further improvements 🛠️

### Handling API key
* Some more 'elegant' way of providing API key to the ``.env`` file.

### Terraform
* There could be a bash script for: parsing the terminal arguments and passing it to example.tfvars + running ``./init``, waiting for the process to complete, copying files from ``example.tfvars`` to ``terraform.tfvars`` and then running ``./apply``, and somehow fetching and passing``YOUR.HOST.PUBLIC.IP`` to the rest of the configuration (coping from example.tfvars to terraform.tfvars could also be skipped with simply passing the arguments directly to newly created terraform.tfvars).
* Fixing the problem with ./apply.sh not displaying ip straight away (in /terraform/main.tf).

### Ansible 
* Possibility of writing a bash script which would execute the ansible playboos in simpler way.

### Full automation (not 100% sure about this)
* Single bash script to fully automate above listed improvements (user provides appropriate args just in one command).

### README
* More consistent with clearer instructions. 
* Section for possible troubleshooting.
* Instructions for running the app locally.
