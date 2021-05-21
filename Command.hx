package;

import js.node.ChildProcess;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Path to the command")
	var cmd:String;
	@:editable("Arguments for the command")
	var ?args:Array<String>;
}

class Command extends IdeckiaAction {
	public function execute(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			var options:ChildProcessSpawnOptions = {
				shell: true,
				detached: true,
				stdio: Ignore
			}

			var cmd = (props.args != null)
						? ChildProcess.spawn(props.cmd, props.args, options)
						: ChildProcess.spawn(props.cmd, options);
			cmd.unref();
			cmd.on('error', reject);
			resolve(currentState);
		});
	}
}
