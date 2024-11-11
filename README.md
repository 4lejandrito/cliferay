# Cliferay

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

cliferay Commands:
  update            Update cliferay to the latest version

Git Commands:
  sync              Sync fork and local copy with upstream
  brian             Forward an existing PR to Brian and close it
  set-ticket        Set the Jira ticket on your local commits
  owner             Output the owner of a path based on CODEOWNERS
  tickets           Gets all Jira tickets from the output of git log
  stats             Calculate different Git stats

Build Commands:
  build             Run ant all
  ij                Run liferay-intellij
  gw                Run gradlew
  ant               Run ant

Module Commands:
  changed-modules   List changed modules
  super-deploy      Deploy changed modules
  format-source     Run SF globally
  deploy            Deploy the current folder
  baseline          Run baseline in the current folder
  build-rest        Run buildREST globally

Server Commands:
  run               Start the server
  gogo              Opens the Gogo Shell
  kill              Kill the server
  nuke              Delete all persisted data
  tomcat-folder     Print the current tomcat folder
  elastic-search    Queries the Elastic Search index
  db-name           Prints the database name (lportal)

Commands:
  morning           Sync, build, ij, nuke and run
  folder            Print the source folder
  curl              Send predefined HTTP requests to a running portal
  backport          Backport commits to other branches
  jira              Open a Jira ticket
  init              Initialize cliferay

Test Commands:
  poshi             Run a Poshi test
  playwright        Playwright utils

Options:
  --help, -h
    Show this help

  --version, -v
    Show version number

Environment Variables:
  LIFERAY_HOME (required)
    Location of your main liferay-portal clone

  DEBUG
    Set to true to enable echoing of all the commands being run
```

## Installation
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
4. If you want to enable aliases (like gw) add this to your `.bash_profile`, `.zshrc` or similar:
    ```bash
    eval "$(cliferay aliases)"
    ```

## Contributing

`cliferay` has been created with https://bashly.dannyb.co. To be able to contribute you'll need to get familiar with it first.

### Modify an existing command
1. Make the change inside `src/commands`.
2. Run `./generate.sh`.
3. Test it `cliferay [COMMAND] ...`
4. Submit a pull request!

### Add a new command
1. Modify `src/bashly.yml` with your new command.
2. Run `./generate.sh`.
3. Implement your command inside `src/commands`.
4. Run `./generate.sh` again.
5. Test it `cliferay [COMMAND] ...`
6. Submit a pull request!