# cliferay todo

Create a todo  
  
Each todo is a folder under $(cliferay data-folder)/todo/todo holding a todo.md and any related files, committed and pushed to the data repository.  
  
The folder is prefixed with its priority, 001 being the most important. A new todo goes first and pushes the rest down. Reprioritize by renaming the folder.  


## Usage

```bash
cliferay todo [--] TITLE...
```

## Examples

```bash
cliferay todo Complete 100% of the milestone
```

```bash
cliferay todo Review PR http://github.com/...
```


