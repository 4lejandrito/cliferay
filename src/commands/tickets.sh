grep -oE 'LP[SD]-[0-9]+' | sort | uniq | sed 's/^/https:\/\/liferay.atlassian.net\/browse\//'