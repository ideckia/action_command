# Action for ideckia: Command

## Definition

Will execute a the given command-line command and arguments

## Properties

| Name | Type | Default | Description | Possible values |
| ----- |----- | ----- | ----- | ----- |
| cmd | String | null | Path to the command | null |
| args | Null&lt;Array&lt;String&gt;&gt; | null | Arguments for the command | null |
| confirm | Null&lt;Bool&gt; | false | Does it need confirmation? | null |

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