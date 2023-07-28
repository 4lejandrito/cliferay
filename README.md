```
cliferay - Daily scripts to work with Liferay

Usage:
  cliferay COMMAND
  cliferay [COMMAND] --help | -h
  cliferay --version | -v

Git Commands:
  sync              Sync fork and local copy with upstream

Build Commands:
  build             Run ant all
  ij                Run liferay-intellij
  gw                Run gradlew

Module Commands:
  changed-modules   List changed modules
  super-deploy      Deploy changed modules

Server Commands:
  run               Start the server
  kill              Kill the server

Commands:
  morning           Sync, build, ij and run
  folder            Print the source folder
  completions       Print completions script
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