# cliferay mysql remove

Remove the MySQL container and its data

## Usage

```bash
cliferay mysql remove [OPTIONS]
```

## Examples

```bash
cliferay mysql remove
```

```bash
cliferay mysql remove --keep-data
```

## Options

#### *--keep-data*

Keep the Docker volume with the databases, so a new container picks them up


