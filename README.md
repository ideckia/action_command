# Command for ideckia: Command

## Definition

Will execute a the given command-line command and arguments

## Example in layout file

```json
{
    "state": {
        "text": "cmd_command project",
        "bgColor": "00ff00",
        "cmd": {
            "name": "command",
            "props": {
                "cmd": "C:/Microsoft VS Code/Code.exe",
                "args": [
                    "C:/development/projects/ideckia/cmd_command.code-workspace"
                ]
            }
        }
    }
}
```