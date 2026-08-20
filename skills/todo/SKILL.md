---

allowed-tools: Bash, Glob, Grep, Read, Edit
argument-hint: "[what to do with your todos]"
description: Read and manage the markdown todo board kept in the cliferay data repository. Use when asked what to work on, what is most important, or to add, read, reprioritize, complete, forget or reopen a todo.
name: todo

---

# Todo

`cliferay` keeps its todos as markdown in its data repository, so managing them is plain file work — reading, moving and renaming folders, then committing. Nobody needs to open the `cliferay todos` board.

## Where it lives

The board is the `todo` directory inside cliferay's data folder: `$CLIFERAY_DATA_FOLDER` when that is set, otherwise the `.data` directory of the cliferay checkout. That data folder is its own git repository, separate from cliferay itself.

## Layout

Five directories, one per list:

| Directory | Holds | Folder names look like |
|---|---|---|
| `todo/` | still to do | `001-review-adolfo-pr` |
| `done/` | finished | `2026-08-19T14-03-10-review-adolfo-pr` |
| `forgotten/` | dropped without being done | `2026-08-19T14-03-10-review-adolfo-pr` |
| `people/` | notes per person | `2022-08-03T12-33-21-meg` |
| `knowledge/` | reference notes | `2026-02-11T09-04-55-batch-engine` |

Every todo is a **folder** holding a `todo.md`, plus any files it refers to by filename — an image, a PDF. The `# ` heading is the title. The frontmatter carries `created`, and optionally `links`, `labels`, `due` and `due_complete`, and nothing else:

```markdown
---
created: 2026-08-10T05:03:46Z
links:
  - https://liferay.atlassian.net/browse/LPD-92464
---

# Look into PoC
```

## Rules

These must hold after anything you do, because the ordering depends on them:

- In `todo/`, the numeric prefix **is** the priority: `001` is the most important. The numbering is **dense** — no gaps, no duplicates — so renumbering the whole list is part of every move in or out of it.
- Elsewhere the prefix is the **UTC** timestamp at which the todo entered that directory, to the second. Set it when something arrives; never rewrite one that is already there.
- `created` records when a todo was first captured, never when it moved. Leave it alone.
- One `todo.md` per folder, always with an `# ` heading. Renaming a folder never means editing the file, and vice versa.

## What the operations mean

- **Listing** is ordered by the prefix, most important first for `todo/` and most recent first for the others. Report ten unless more are asked for. Never infer order from the order a search tool happens to return files in — some `grep` builds scan in parallel and answer out of order, so sort deliberately.
- **Reading** one is worth more than its title: its links and any unchecked `- [ ]` items are the actual open work.
- **Adding** one belongs to the CLI — `cliferay todo <title>` slugifies, writes the frontmatter, puts it first and commits and pushes. A fresh todo ranks first because it is the thing on your mind right now, and the rest shift one down; demote it only if the user says it can wait. URLs in the title become `links`.
- **Completing** moves the folder into `done/` under the current UTC second, and closes the gap it left behind.
- **Forgetting** is the same move into `forgotten/`, for a todo that is being dropped rather than finished — the linked work is closed, the moment passed, or it stopped mattering. Never file one of these under `done/`; the distinction between finished and abandoned is the whole point of the list.
- **Reopening** brings it back as the most important todo, pushing the rest down. It works from `done/` and from `forgotten/` alike.
- **Reprioritizing** is renaming, not rewriting: put the folder where it belongs in the order, then make the numbering dense again.

## Finishing

Commit what you changed to the data repository in a single commit and push it, describing it the way the board does: `Done: <title>`, `Forget: <title>`, `Reopen: <title>`, `Reprioritize: <title>`. Adding a todo through the CLI is already committed and pushed — do not commit it twice. If the push fails, say so; the work is safe locally.

## Output

Answer in the conversation and keep it short. List one todo per line as its number and title, without paths unless asked. After changing anything, say what moved and where it ended up — the directory a completed todo landed in, or the new priority of one you moved.
