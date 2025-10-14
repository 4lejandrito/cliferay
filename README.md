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
  aliases           Print aliases script
  completions       Print completions script
  update            Update cliferay to the latest version

Build Commands:
  ant               Run ant
  build             Run ant all
  gw                Run gradlew
  ij                Run liferay-intellij
  morning           Sync, build, ij, nuke and run

Server Commands:
  curl              Send HTTP requests to the server
  elastic-search    Query the Elastic Search index
  gogo              Open the Gogo Shell
  kill              Kill the server
  nuke              Delete all persisted data
  run               Start the server
  sql               Run a SQL query against the Liferay database

Code Commands:
  baseline          Run baseline in the current folder
  build-rest        Run buildREST globally
  changed-modules   List changed modules
  deploy            Deploy the current folder
  home              Print the current Liferay home folder
  format-source     Run SF globally
  owner             Output the owner of a path based on CODEOWNERS
  poshi             Run a Poshi test
  super-deploy      Deploy changed modules

Git Commands:
  brian             Forward an existing PR to Brian and close it
  backport          Backport commits to other branches
  set-ticket        Set the Jira ticket on your local commits
  stats             Calculate different Git stats
  sync              Sync fork and local copy with upstream
  tickets           Get all Jira tickets from the output of git log

Jira Commands:
  jira              Open a Jira ticket in the browser

GTD Commands:
  todo              Create a todo in Trello
  todos             List todos from Trello

Options:
  --help, -h
    Show this help

  --version, -v
    Show version number

Environment Variables:
  DEBUG
    Set to true to enable echoing of all the commands being run
```

## Installation
1. Clone this repo.
2. Add the bin folder to your path:
    ```bash
    export PATH=/path/to/cliferay/bin:$PATH
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

> [!IMPORTANT]
> If you're working on macOS, you need to install `coreutils`. You can install it via Homebrew:
>
> ```sh
> brew install coreutils
> ```
>
> Then, add the `gnubin` directory to your `PATH` in your `.zshrc` or `.bashrc`:
>
> ```sh
> # Use coreutils installed via Homebrew: https://www.gnu.org/software/coreutils/
> export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
> ```

## Contributing

`cliferay` has been created with https://bashly.dev. To be able to contribute you'll need to get familiar with it first.

### Modify an existing command
1. Make the change inside `src/commands`.
2. Run `make`.
3. Test it `cliferay [COMMAND] ...`
4. Submit a pull request!

### Add a new command
1. Modify `src/bashly.yml` with your new command.
2. Run `make`.
3. Implement your command inside `src/commands`.
4. Run `make` again.
5. Test it `cliferay [COMMAND] ...`
6. Submit a pull request!
