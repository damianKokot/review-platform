export PROJECT_NAME=v1

export TF_ARGS="-backend-config=backend.tfvars.json"

EXEC=docker compose run -it --rm -e WORKDIR -w /code/${PROJECT_NAME}/ app 

build:
	docker compose build

encrypt:
	@ WORKDIR=/code/ ${EXEC} sops_encrypt backend.tfvars.json backend.tfvars.enc.json
	@ WORKDIR=/code/ ${EXEC} sops_encrypt secret.auto.tfvars.json secret.auto.tfvars.enc.json
	@ WORKDIR=/code/ ${EXEC} sops_encrypt inventory.yaml inventory.enc.yaml

decrypt:
	@ WORKDIR=/code/ ${EXEC} sops_decrypt backend.tfvars.enc.json backend.tfvars.json
	@ WORKDIR=/code/ ${EXEC} sops_decrypt secret.auto.tfvars.enc.json secret.auto.tfvars.json
	@ WORKDIR=/code/ ${EXEC} sops_decrypt inventory.enc.yaml inventory.yaml

init:
	WORKDIR=./infrastructure ${EXEC} sh -c " \
		test -d .terraform && rm -rf .terraform \
		|| terraform init ${TF_ARGS} \
	"

fmt:
	WORKDIR=/code/ ${EXEC} terraform fmt -recursive

plan:
	WORKDIR=./infrastructure ${EXEC} terraform plan 

apply:
	WORKDIR=./infrastructure ${EXEC} terraform apply

shell:
	${EXEC} sh

# As for now there is only one server. Connect to it
ssh-connect:
	$(eval HOST=$(shell ${EXEC} yq '.all.hosts.master.ansible_host' ./configuration/inventory.yaml))
	${EXEC} ssh -i /root/.ssh/id_rsa root@$(HOST)
