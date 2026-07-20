# cliferay run

Start the server

## Usage

```bash
cliferay run [COMMAND] [OPTIONS]
```

## Examples

```bash
cliferay run --profile mcp-oauth
```

## Arguments

#### *COMMAND*

Tomcat command

## Options

#### *--profile, -p PROFILE*

Run profile with extra properties and OSGi configs.  
Profiles live in src/run-profiles/\<profile\> and are layered on  
top of the shared baseline. A profile's catalina-opts file  
(e.g. -Dliferay.mode=test) is added to CATALINA_OPTS for the run.  



