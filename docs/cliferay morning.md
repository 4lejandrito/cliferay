# cliferay morning

Run sync, build, ij, nuke and run  
  
Starts the 'cliferay mysql' container first unless a MySQL server is already listening on localhost:3306.  


## Usage

```bash
cliferay morning [OPTIONS]
```

## Options

#### *--brian*

Sync from Brian instead of upstream

#### *--no-nuke*

Skip the nuke step

#### *--force, -f*

Force cleanup by running 'git clean -fdx'


