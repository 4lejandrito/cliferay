# cliferay

Daily scripts for working with Liferay  
  
You can run these scripts from any folder:  
  - If you are outside a repository, LIFERAY_HOME will be used.  
  - If you are inside a repository, that repository will be used.  
  
For example, every day I open my terminal and type:  
  
  \> cliferay morning  
  
and it will work, no matter which folder I am in.  


| Attributes       | &nbsp;
|------------------|-------------
| Version:         | 1.0.0

## Usage

```bash
cliferay COMMAND
```

## Dependencies

#### *gh*

Install from https://cli.github.com

#### *jq*

Install from https://jqlang.github.io/jq

## Environment Variables

#### *DEBUG*

Set to true to echo all commands being run

## cliferay Commands

- [aliases](cliferay%20aliases.md) - Print the aliases script
- [completions](cliferay%20completions.md) - Print the completions script
- [repo](cliferay%20repo.md) - Open the cliferay GitHub repository in the browser
- [update](cliferay%20update.md) - Update cliferay to the latest version

## Build Commands

- [ant](cliferay%20ant.md) - Run ant
- [build](cliferay%20build.md) - Run 'ant all'
- [bundle](cliferay%20bundle.md) - Set up bundle from https://releases.liferay.com
- [gw](cliferay%20gw.md) - Run gradlew
- [ij](cliferay%20ij.md) - Run liferay-intellij
- [morning](cliferay%20morning.md) - Run sync, build, ij, nuke and run

## Server Commands

- [chat](cliferay%20chat.md) - Chat with the server
- [curl](cliferay%20curl.md) - Send HTTP requests to the server
- [docker](cliferay%20docker.md) - Start a Liferay Docker container
- [elastic-search](cliferay%20elastic-search.md) - Query the Elasticsearch index
- [gogo](cliferay%20gogo.md) - Open the Gogo Shell
- [kill](cliferay%20kill.md) - Kill the server
- [nuke](cliferay%20nuke.md) - Delete all persisted data
- [run](cliferay%20run.md) - Start the server
- [sql](cliferay%20sql.md) - Run a SQL query against the Liferay database

## Code Commands

- [baseline](cliferay%20baseline.md) - Run baseline in the current folder
- [build-rest](cliferay%20build-rest.md) - Run buildREST globally
- [changed-modules](cliferay%20changed-modules.md) - List changed modules
- [deploy](cliferay%20deploy.md) - Deploy the current folder
- [home](cliferay%20home.md) - Print the current Liferay home folder path
- [format-source](cliferay%20format-source.md) - Run Source Formatter globally
- [owner](cliferay%20owner.md) - Output the owner of a path based on CODEOWNERS
- [poshi](cliferay%20poshi.md) - Run a Poshi test
- [super-deploy](cliferay%20super-deploy.md) - Deploy changed modules

## Git Commands

- [brian](cliferay%20brian.md) - Forward an existing PR to Brian and close it
- [backport](cliferay%20backport.md) - Backport commits to other branches
- [set-ticket](cliferay%20set-ticket.md) - Set the Jira ticket on your local commits
- [stats](cliferay%20stats.md) - Calculate various Git statistics
- [sync](cliferay%20sync.md) - Sync fork and local copy with upstream
- [tickets](cliferay%20tickets.md) - Extract all Jira tickets from the output of 'git log'

## Jira Commands

- [jira](cliferay%20jira.md) - Open a Jira ticket in the browser

## GTD Commands

- [todo](cliferay%20todo.md) - Create a todo in Trello
- [todos](cliferay%20todos.md) - List todos from Trello


