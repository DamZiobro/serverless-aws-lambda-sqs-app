#
# Makefile
#

#set default ENV based on your username and hostname
APP_DIR=app
TEST_DIR=tests
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD | sed -r 's/[\/]+/-/g')
ENV ?= $(GIT_BRANCH)

all: deploy test

deploy:
	@echo "======> Deploying to env $(ENV) <======"
ifeq ($(FUNC),)
	sls deploy --stage $(ENV)
else
	sls deploy --stage $(ENV) -f $(FUNC) 
endif

run:
	@echo "======> Running app on env $(ENV) <======"
	sls invoke --stage $(ENV) -f lambda_function1

logs:
	@echo "======> Getting logs from env $(ENV) <======"
	sls logs --stage $(ENV) -f lambda_function1
	sls logs --stage $(ENV) -f lambda_function2

destroy:
	@echo "======> DELETING in env $(ENV) <======"
	sls remove --stage $(ENV)

requirements:
	pip install -r ${APP_DIR}/requirements.txt
	pip install -r ${APP_DIR}/test-requirements.txt
	touch $@

#==========================================================================
# Test and verify quality of the app
unittest: requirements
	python -m unittest discover ${TEST_DIR}

coverage: requirements
	python -m coverage --version
	python -m coverage run --source ${APP_DIR} --branch -m unittest discover -v 
	python -m coverage report -m
	python -m coverage html

lint: requirements
	python -m pylint --version
	python -m pylint ${APP_DIR}

security:
	python -m bandit --version
	python -m bandit ${APP_DIR}

code-checks: lint security

ci: code-checks unittest coverage

.PHONY: test deploy destroy unittest coverage lint security
