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
				stdio: 'ignore'
			}
			var cmd = ChildProcess.spawn(props.cmd, props.args, options);
			cmd.unref();
			cmd.disconnect();
	
			return resolve(currentState);
		});
	}
}
