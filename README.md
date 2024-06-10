# Weatherapp ☀️
Weatherapp project deployment encorporating Azure cloud hosting, Terraform and Ansible automation, containerization as well as reverse proxy handling.

## Prequisities ✅
Ensure you obtained API key from [openweather](https://openweathermap.org/). Also you need to have those tools installed:
* Azure CLI [(instructions)](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* Terraform [(instructions)](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Ansible [(instructions)](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* If you want to access the app locally you'll also need [Docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/)

## Setup ⚙️
All you need to access the weather service is a moment for simple configuration and you'll be ready to go! Isn't that awesome?

### Login to Azure CLI
In your terminal run:
```sh
az login
```

### Configure Terraform
* First go to 'terraform' directory:
```
cd terraform
```
* Open 'example.tfvars' in any text editor e.g. vim:
```sh
vim example.tfvars
```
* Provide appropriate data:
```sh

resource_group_name = "<your-unique-resource-group-name>"
location            = "<prefferedlocation>"
ssh_public_key      = "/your/absolute/rsa/public/key/path.pub"
supervisor_ssh_public_key = "/supervisor/absolute/rsa/public/key/path.pub"
computer_name       = "<yourhostname>"
admin_username      = "<yourusername>"
disable_password_authentication = <true_or_false> 
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
```sh
public_ip_address = "" -> "YOUR.HOST.PUBLIC.IP"
```

### Configure .env
* Navigate to the project root directory and edit ``.env`` file providing necessary data:
```sh
ENDPOINT=http://YOUR.HOST.PUBLIC.IP/api
APPID=your-api-key
```
### Configure Ansible inventories
Before running the playbooks we need to navigate to ``ansible/inventories`` from the project root dit and provide ``<YOUR.HOST.PUBLIC.IP>``, ``<admin_username>``, and ``<ssh_public_key>`` from ``example.tfvars`` file.

## Deployment 👷

### Run Ansible playbooks
We're almost done! To deploy your application first we need to install Docker and docker-compose on your host.
* In the terminal run:
```sh
ansible-playbook -i ansible/inventories/cloud ansible/playbooks/install_docker.yml 
```
Now having Docker and docker-compose installed it's time to finally deploy your weather service.
* Run this command as superuser (coping files) and provide your password:
```sh
sudo ansible-playbook -i ansible/inventories/cloud ansible/playbooks/deploy_app.yml 
```

## Usage 💃

In order to admire the true beauty of your freshly deployed weather service simply go to your browser and type:
``YOUR.HOST.PUBLIC.IP``
The same you obtained earlier, after configuring Terraform.

## Deleting the infrastructure 💥
If for some reason you didn't like your setup and want to ``🔥 destroy 🔥`` (delete) the infrastructure, simply follow those steps:
* ``SSH`` into your cloud host:
```ssh
ssh -i ~/path/to/your/private/rsa/key yourusername@YOUR.HOST.PUBLIC.IP"
```
* Navigate to the root project directory and run:
```sh
sudo docker-compose down
```
* Now you can ``logout`` from the cloud host machine, and in your controll (local) terminal navigate to ``terraform`` directory and run:
```sh
./destroy.sh
```
Now wait till your Azure resources will be completely deleted.

## Possible further improvements 🛠️

### Handling API key
* Some more 'elegant' way of providing API key to the ``.env`` file.

### Terraform
* There could be a bash script for running ``./init``, waiting for the process to complete, copying files from ``example.tfvars`` to ``terraform.tfvars`` and then running ``./apply``, and somehow fetching ``YOUR.HOST.PUBLIC.IP`` to the rest of configuration.

### Ansible 
* Possibility of writing bash script executing the ansible playboos in simpler way.

### Full automation (not 100% sure about this)
* Single bash script to fully automate above listed improvements.

### README
* More consistent with clearer instructions. 
* Section for possible troubleshooting.
* Instructions for running the app locally.
