export PROJECT_NAME=common/remote-state

export TF_ARGS="-backend-config=backend.tfvars"

build:
	docker compose build

tf-init:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app sh -c " \
		rm -rf .terraform \
		&& terraform init ${TF_ARGS} \
	"

tf-fmt:
	docker compose run -it --rm -w /code/ app terraform fmt -recursive

tf-plan:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app terraform plan 

tf-apply:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app terraform apply

shell:
	docker compose run -it --rm -w /code/${PROJECT_NAME} app sh
