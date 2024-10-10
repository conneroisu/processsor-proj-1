all: say_hello generate

say_hello:
	@echo "Hello World"

generate:
	@echo "Launching questasim in test directory..."
	cd proj/test; pwd; questasim .

clean:
	@echo "Cleaning up..."
	rm *.txt
