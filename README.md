```
cliferay

  Daily scripts to work with Liferay
  
  The scripts can be run from any folder:
    - If the folder is outside the repo it will use LIFERAY_HOME.
    - If the folder is inside the repo it will use that repo. 
    
  For example every day I open my terminal and type:
  
    > cliferay morning
  
  and it will just work no matter which folder I am in.

Usage:
  cliferay COMMAND
  cliferay [COMMAND] --help | -h
  cliferay --version | -v

Git Commands:
  sync              Sync fork and local copy with upstream
  brian             Forward an existing PR to Brian and close it

Build Commands:
  build             Run ant all
  ij                Run liferay-intellij
  gw                Run gradlew

Module Commands:
  changed-modules   List changed modules
  super-deploy      Deploy changed modules
  format-source     Run SF globally

Server Commands:
  run               Start the server
  kill              Kill the server
  nuke              Delete all persisted data
  tomcat-folder     Print the current tomcat folder

Commands:
  morning           Sync, build, ij and run
  folder            Print the source folder
  completions       Print completions script

Options:
  --help, -h
    Show this help

  --version, -v
    Show version number

Environment Variables:
  LIFERAY_HOME (required)
    Location of your main liferay-portal clone
```

# Installation
1. Clone this repo.
2. Add it to your path:
    ```bash
    export PATH=/path/to/cliferay:$PATH
    ```
3. Run it!
    ```bash
    cliferay --help
    ```
4. If you want to enable bash completions add this to your `.bash_profile`, `.zshrc` or similar:
    ```bash
    eval "$(cliferay completions)"
    ```
----
Created with https://bashly.dannyb.co.