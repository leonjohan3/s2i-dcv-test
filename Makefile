IMAGE_NAME = dcv-image
S2I_IMAGE_NAME = s2i-dcv-test

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .
	s2i build . $(IMAGE_NAME) $(S2I_IMAGE_NAME)
	#s2i build . $(IMAGE_NAME) $(S2I_IMAGE_NAME) --incremental=true

.PHONY: deploy
deploy: build
	docker run -d --rm --name $(S2I_IMAGE_NAME) -p 8000:8000 $(S2I_IMAGE_NAME)
