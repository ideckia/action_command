# Action for [ideckia](https://ideckia.github.io/): Command

## Definition

Execute a the given command-line command and arguments. If it is a sensible command, you can ask for confirmation before the execution (`props.confirm = true`).

Usually (in my case) I want to run the command and forget about it. But sometimes I want to be notified with the command output or possible errors. In that case, use `props.detached = false`.

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| command | String | Path to the command | false | null | null |
| args | Null&lt;Array&lt;String&gt;&gt; | Arguments for the command | false | null | null |
| confirm | Null&lt;Bool&gt; | Does it need confirmation? | false | false | null |
| detached | Null&lt;Bool&gt; | Run the command and don't wait for any response? | false | true | null |

## Example in layout file

```json
{
    "state": {
        "text": "action_command project",
        "bgColor": "00ff00",
        "actions": [
            {
                "name": "command",
                "props": {
                    "command": "code",
                    "args": [
                        "/dev/projects/ideckia/action_command.code-workspace"
                    ]
                }
            }
        ]
    }
}
```