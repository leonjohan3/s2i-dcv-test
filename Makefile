IMAGE_NAME = leonjohan3atyahoodotcom/tomcat9-apache2-httpd:1.0.0
S2I_IMAGE_NAME = s2i-dcv-test

.PHONY: build
build:
	#git diff --quiet
	#test -z "$$(git status --porcelain)" || exit 1
	s2i build . $(IMAGE_NAME) $(S2I_IMAGE_NAME) --incremental=false
	#s2i build . $(IMAGE_NAME) $(S2I_IMAGE_NAME) --incremental=true

.PHONY: deploy
deploy: build
	#docker run -d --rm --name $(S2I_IMAGE_NAME) -p 8000:8000 $(S2I_IMAGE_NAME)
	#docker run -d --rm --name $(S2I_IMAGE_NAME) -p 8000:8080 -v /home/ubuntu/projects/log:/opt/app-root/src/var/log $(S2I_IMAGE_NAME)
	# TODO - change KSP_START before release
	docker run --rm -m 272m -d --name $(S2I_IMAGE_NAME) -e KSP_START='.key' -p 80:8000 -p 443:8443 -v /home/ubuntu/projects/log:/opt/app-root/src/var/log -v /home/ubuntu/projects/db:/opt/app-root/src/db $(S2I_IMAGE_NAME)
	#docker run -d --name $(S2I_IMAGE_NAME) -p 80:8000 -p 443:8443 -v /home/ubuntu/projects/log:/opt/app-root/src/var/log $(S2I_IMAGE_NAME)
	#docker run -d --rm --name $(S2I_IMAGE_NAME) -p 8000:8080  $(S2I_IMAGE_NAME)
