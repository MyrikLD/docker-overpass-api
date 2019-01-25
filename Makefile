include conf.sh
run: build
	docker run -d \
	--restart=unless-stopped \
	-v $(OVERPASS_DB_DIR):/overpass_DB \
	-p $(SERVER_HTTP_PORT):80 \
	overpass_api

build:
	docker build -t overpass_api .
