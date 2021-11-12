#
# Makefile
#

#set default ENV based on your username and hostname
APP_DIR=app
TEST_DIR=tests
#get name of GIT branchse => remove 'feature/' if exists and limit to max 20 characters
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD | sed -r 's/[\/]+/-/g' | sed -r 's/feature-//g' | cut -c 1-20)
ENV ?= $(GIT_BRANCH)
AWS_DEFAULT_REGION ?= eu-west-1

#==========================================================================
# Test and verify quality of the app
serverless:
	#install serverless framework for Continous Deployment
	npm install -g serverless@1.51.0 || true
	sls plugin install -n serverless-plugin-cloudwatch-dashboard
	sls plugin install -n serverless-python-requirements
	touch $@


requirements: serverless
	pip install -r requirements.txt
	pip install -r tests/test-requirements.txt
	touch $@

unittest: requirements
	python -m unittest discover ${TEST_DIR}

coverage: requirements
	python -m coverage --version
	python -m coverage run --source ${APP_DIR} --branch -m unittest discover -v 
	python -m coverage report -m
	python -m coverage html

format: requirements
	python -m isort $(APP_DIR) $(TEST_DIR)
	python -m black $(APP_DIR) $(TEST_DIR)

lint: requirements
	python -m pylint --version
	python -m pylint ${APP_DIR} ${TEST_DIR}

isort: requirements
	python -m isort --check-only $(APP_DIR)/**.py $(TEST_DIR)/**.py

black: requirements
	python -m black --check $(APP_DIR) $(TEST_DIR)

security: requirements
	python -m bandit --version
	python -m bandit ${APP_DIR}

code-checks: isort black lint security

deploy:
	@echo "======> Deploying to env $(ENV) <======"
ifeq ($(FUNC),)
	sls deploy --stage $(ENV) --verbose --region $(AWS_DEFAULT_REGION)
else
	sls deploy --stage $(ENV) -f $(FUNC) --verbose --region $(AWS_DEFAULT_REGION)
endif

run: requirements
	@echo "======> Running app on env $(ENV) <======"
	sls invoke --stage $(ENV) -f lambda_function1

sleep:
	sleep 5

logs: requirements
	@echo "======> Getting logs from env $(ENV) <======"
	sls logs --stage $(ENV) -f lambda_function1
	sls logs --stage $(ENV) -f lambda_function2

run-and-logs: run sleep logs

e2e-tests: requirements run-and-logs

load-tests: requirements
	@echo -e "load-tests not implemented yet"

destroy: requirements
	@echo "======> DELETING in env $(ENV) <======"
	sls remove --stage $(ENV) --verbose --region $(AWS_DEFAULT_REGION)

ci: code-checks unittest coverage
cd: ci deploy e2e-tests load-tests

.PHONY: e2e-test deploy destroy unittest coverage lint security code-checks run logs destroy
