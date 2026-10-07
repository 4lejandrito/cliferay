# cliferay mysql

Manage a MySQL Docker container for the Liferay database  
  
The container is called cliferay-mysql. It listens on localhost:3306 with user root and password root, and keeps its data in the cliferay-mysql Docker volume, so it works out of the box with 'cliferay run', 'cliferay nuke', 'cliferay sql' and 'cliferay switch'.  
  
While it is running, 'cliferay nuke' and 'cliferay sql' go through the container, so no local mysql client is needed.  


## Usage

```bash
cliferay mysql COMMAND
```

## Commands

- [create](cliferay%20mysql%20create.md) - Create and start the MySQL container, with the current database already created
- [start](cliferay%20mysql%20start.md) - Start the MySQL container
- [stop](cliferay%20mysql%20stop.md) - Stop the MySQL container, keeping its data
- [remove](cliferay%20mysql%20remove.md) - Remove the MySQL container and its data


