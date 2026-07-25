# rust_create_script
# cargo_new.sh

Creates a new Cargo project and automatically adds it to the `members` list of the workspace `Cargo.toml`.

## Usage

```bash
./cargo_new.sh <project-name>
```

Run the script from the root of your Cargo workspace (where the `Cargo.toml` with the `[workspace]` section lives).

## What it does

1. Checks that a project name was provided.
2. Checks that a `Cargo.toml` with a `[workspace]` section exists in the current directory.
3. Checks that no folder with the project name already exists.
4. Runs `cargo new <project-name>`.
5. Adds the new project name to the `members = [...]` list in the workspace `Cargo.toml` (if not already present).

## Example

```bash
cd my-workspace
./cargo_new.sh my-new-crate
cd my-new-crate
code .
```

## Requirements

- Bash
- Rust/Cargo installed
- A workspace `Cargo.toml` in the current directory

## Error messages

| Message | Cause |
|---|---|
| Kein Projektname angegeben | Script called without an argument |
| Keine Cargo.toml im aktuellen Verzeichnis gefunden | Script not run from the workspace root |
| Die Cargo.toml enthält keinen [workspace] Abschnitt | Found Cargo.toml is not a workspace file |
| Ordner '...' existiert bereits | Project name is already taken |

## Note

The `Cargo.toml` entry is added via `sed` and assumes a `members = [...]` list with a closing `]` on its own line. Check manually if your formatting differs significantly.
