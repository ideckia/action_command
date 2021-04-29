# Action for ideckia: Command

## Definition

Will execute a the given command-line command and arguments

## Example in layout file

```json
{
    "state": {
        "text": "action_command project",
        "bgColor": "00ff00",
        "action": {
            "name": "command",
            "props": {
                "cmd": "C:/Microsoft VS Code/Code.exe",
                "args": [
                    "C:/development/projects/ideckia/action_command.code-workspace"
                ]
            }
        }
    }
}
```