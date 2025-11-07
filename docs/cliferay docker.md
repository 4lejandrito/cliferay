# cliferay docker

Start a Liferay Docker container  
  
You can configure it by placing files under $(cliferay data-folder)/docker  
  
That folder will be copied on startup to .docker and mounted into the container, for runtime changes do it in the .docker folder  
  
https://learn.liferay.com/w/dxp/self-hosted-installation-and-upgrades/using-liferay-docker-images/providing-files-to-the-container  


## Usage

```bash
cliferay docker [IMAGE]
```

## Examples

```bash
cliferay docker
```

```bash
cliferay docker portal:7.4.3.132-ga132
```

## Arguments

#### *IMAGE*

The Docker image name and optional tag to run

| Attributes      | &nbsp;
|-----------------|-------------
| Default Value:  | portal


