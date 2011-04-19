all:
	@@echo "Since the whole script is in makeJSFile.sh, there is nothing to build."
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
	@@${shell echo -e ./makeFile.sh -l js example/input} > example/output/js-object.js
	@@${shell echo -e ./makeFile.sh -l js -k 0 example/input} > example/output/js-array.js
	@@${shell echo -e ./makeFile.sh -l php example/input} > example/output/php-associative-array.js
	@@${shell echo -e ./makeFile.sh -l php -k 0 example/input} > example/output/php-indexed-array.js
	@@echo "Finished building example."
	@@echo "Run 'make clean' to remove it."

none:
	@@${shell echo -e ./makeFile.sh -x -o '[' -c ']' example/input} > example/output/JSON-array.js
	@@${shell echo -e ./makeFile.sh -d -e '\ =\ ' -b 'var\ ' -a '\ ' example/input} > example/output/var-assignments.js
