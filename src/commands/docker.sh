mkdir -p $(cliferay data-folder)/docker
rm -rf $(cliferay data-folder)/.docker
cp -r $(cliferay data-folder)/docker $(cliferay data-folder)/.docker
docker run -it --rm -m 8g -p 8080:8080 -p 11311:11311 -p 9200:9200 -p 8000:8000 -e LIFERAY_JPDA_ENABLED=true -v $(cliferay data-folder)/.docker:/mnt/liferay "liferay/${args["image"]}"