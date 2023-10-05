LIGO_VER=1.0.0
LIGO=docker run --platform linux/amd64 --rm -v "$(PWD)":"$(PWD)" -w "$(PWD)" ligolang/ligo:$(LIGO_VER)
JSON_OPT=--michelson-format json

##########################################

refuse_analytics:
	@$(LIGO) analytics deny

compile: src/votingContract.mligo
	@echo "Compiling smart contract to Michelson..."
	@$(LIGO) compile contract $^ --output-file compiled/main.tz
	@$(LIGO) compile contract $^ --output-file compiled/main.json $(JSON_OPT)

test: test-ligo test-python

test-ligo: tests/votingContract.test.mligo
	@$(LIGO) run test $^

test-python:
	@python3 tests/python/votingContract.test.py