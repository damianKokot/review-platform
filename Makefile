export PROJECT_NAME=v1/infrastructure

export TF_ARGS="-backend-config=backend.tfvars.json"

build:
	docker compose build

encrypt:
	@ docker compose run -it --rm -w /code/ app sops_encrypt backend.tfvars.json backend.tfvars.enc.json
	@ docker compose run -it --rm -w /code/ app sops_encrypt secret.auto.tfvars.json secret.auto.tfvars.enc.json

decrypt:
	@ docker compose run -it --rm -w /code/ app sops_decrypt backend.tfvars.enc.json backend.tfvars.json
	@ docker compose run -it --rm -w /code/ app sops_decrypt secret.auto.tfvars.enc.json secret.auto.tfvars.json

init:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app sh -c " \
		test -d .terraform && rm -rf .terraform \
		|| terraform init ${TF_ARGS} \
	"

fmt:
	docker compose run -it --rm -w /code/ app terraform fmt -recursive

plan:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app terraform plan 

apply:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app terraform apply

shell:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app sh
