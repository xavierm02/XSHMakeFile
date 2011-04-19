all:
	@@echo "Since the whole script is in XSHMakeFile.sh, there is nothing to build."
	@@echo "If you want to try the script on the example data, run 'make example'."
	
clean:
	@@echo "Removing example."
	@@rm -rf example/output
	@@echo "Finished removing example."
	@@echo "Run 'make example' to rebuild it."

example: example/output

example/output:
	@@echo "Building example."
	@@mkdir -p example/output
	@@${shell echo -e ./XSHXSHMakeFile.sh -l js example/input} > example/output/js-object.js
	@@${shell echo -e ./XSHMakeFile.sh -l js -k 0 example/input} > example/output/js-array.js
	@@${shell echo -e ./XSHMakeFile.sh -l php example/input} > example/output/php-associative-array.js
	@@${shell echo -e ./XSHMakeFile.sh -l php -k 0 example/input} > example/output/php-indexed-array.js
	@@echo "Finished building example."
	@@echo "Run 'make clean' to remove it."
