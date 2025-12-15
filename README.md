# Cliferay

Read [the full documentation](docs/README.md).

```
cliferay

  Daily scripts for working with Liferay
  
  You can run these scripts from any folder:
    - If you are outside a repository, LIFERAY_HOME will be used.
    - If you are inside a repository, that repository will be used.
    
  For example, every day I open my terminal and type:
  
    > cliferay morning
  
  and it will work, no matter which folder I am in.

Usage:
  cliferay COMMAND
  cliferay [COMMAND] --help | -h
  cliferay --version | -v

cliferay Commands:
  aliases           Print the aliases script
  completions       Print the completions script
  repo              Open the cliferay GitHub repository in the browser
  update            Update cliferay to the latest version

Build Commands:
  ant               Run ant
  build             Run 'ant all'
  bundle            Set up bundle from https://releases.liferay.com
  gw                Run gradlew
  ij                Run liferay-intellij
  morning           Run sync, build, ij, nuke and run

Server Commands:
  chat              Chat with the server
  curl              Send HTTP requests to the server
  docker            Start a Liferay Docker container
  elastic-search    Query the Elasticsearch index
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
  home              Print the current Liferay home folder path
  format-source     Run Source Formatter globally
  owner             Output the owner of a path based on CODEOWNERS
  poshi             Run a Poshi test
  super-deploy      Deploy changed modules

Git Commands:
  brian             Forward an existing PR to Brian and close it
  backport          Backport commits to other branches
  set-ticket        Set the Jira ticket on your local commits
  stats             Calculate various Git statistics
  sync              Sync fork and local copy with upstream
  tickets           Extract all Jira tickets from the output of 'git log'

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
    Set to true to echo all commands being run
```

## Installation

1. Clone this repo.
2. Add the `bin` folder to your path:
    ```bash
    export PATH=/path/to/cliferay/bin:$PATH
    ```
3. Run it!
    ```bash
    cliferay --help
    ```
4. To enable bash completions, add this to your `.bash_profile`, `.zshrc`, or similar:
    ```bash
    eval "$(cliferay completions)"
    ```
5. To enable aliases (like `gw`), add this to your `.bash_profile`, `.zshrc`, or similar:
    ```bash
    eval "$(cliferay aliases)"
    ```

> **Note for macOS users:**
> You need to install `coreutils`. You can install it via Homebrew:
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

`cliferay` was created with [bashly.dev](https://bashly.dev). To contribute, please familiarize yourself with it first.

### Modify an existing command

1. Make changes inside `src/commands`.
2. Run `make`.
3. Test with `cliferay [COMMAND] ...`
4. Submit a pull request!

### Add a new command

1. Update `src/bashly.yml` with your new command.
2. Run `make`.
3. Implement your command inside `src/commands`.
4. Run `make` again.
5. Test with `cliferay [COMMAND] ...`
6. Submit a pull request!
