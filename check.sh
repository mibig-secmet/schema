#!/bin/bash

check() {
	WITHOUT_EXT=${1/\.json/}
	EXAMPLE_PATH="examples/${WITHOUT_EXT#schemas/}"
	echo "Testing $1"
	check-jsonschema --check-metaschema $1
	echo "Testing examples"
	check-jsonschema --schemafile $1 ${EXAMPLE_PATH}/*.json
	return $?
}

if [ -n "$1" ]; then
	check $1
	exit $?
fi

NUM_FAILED=0
for f in $(find schemas -name "*.json"); do
	check $f || NUM_FAILED=$((NUM_FAILED + 1))
done
echo "$NUM_FAILED checks failed"

exit $NUM_FAILED
