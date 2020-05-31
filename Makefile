#
# Makefile
#

#set default ENV based on your username and hostname
ENV ?= $(USER)

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

test:
	@echo "======> Testing in env $(ENV) <======"
	sls invoke 

.PHONY: test deploy destroy
