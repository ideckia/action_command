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
	public function execute(currentState:ItemState):ItemState {
		var cmd = ChildProcess.spawn(props.cmd, props.args, {shell: true});

		cmd.stdout.on('data', function(data) {
			server.log.debug('stdout: ' + data);
		});

		cmd.on('error', function(code) {
			var args = (props.args == null) ? '' : props.args.join(' ');
			server.log.error('Something went wrong (code=$code) executing [${props.cmd} ${args}]');
		});

		return currentState;
	}
}
