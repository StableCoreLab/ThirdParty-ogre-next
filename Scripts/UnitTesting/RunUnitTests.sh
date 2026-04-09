ARCH=$(uname -m)
BIN_DIR="../../../bin/${ARCH}/Debug/"

case "$OSTYPE" in
	darwin*)
		python3 RunUnitTests.py metal "${BIN_DIR}" ./JSON ../../../UnitTestsOutput/
		;;
	*)
		# python3 RunUnitTests.py gl "${BIN_DIR}" ./JSON ../../../UnitTestsOutput/ ../../../UnitTestsOutput_old/
		python3 RunUnitTests.py vk "${BIN_DIR}" ./JSON ../../../UnitTestsOutput/
		;;
esac
