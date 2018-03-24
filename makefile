docker_name=conda-book

all: stop rm build run

stop:
	docker stop ${docker_name} || true
rm:
	docker rm ${docker_name} || true
build:
	docker build -t ${docker_name} .
run:
	docker run -it -p 8888:8888 ${docker_name} 
