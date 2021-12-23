package;

import js.node.ChildProcess;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Path to the command")
	var cmd:String;
	@:editable("Arguments for the command")
	var ?args:Array<String>;
	@:editable("Does it need confirmation?", false)
	var ?confirm:Bool;
	@:editable("Password", '')
	var password:String;
}

@:name('command')
@:description('Executes system command with given parameters')
class Command extends IdeckiaAction {
	public function execute(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			function exec() {
				var options:ChildProcessSpawnOptions = {
					shell: true,
					detached: true,
					stdio: Ignore
				}

				var cmd = (props.args != null) ? ChildProcess.spawn(props.cmd, props.args, options) : ChildProcess.spawn(props.cmd, options);
				cmd.unref();
				cmd.on('error', reject);
				if (props.password != '')
					cmd.stdin.write(props.password + '\n');

				resolve(currentState);
			}

			if (props.confirm) {
				server.dialog.question('Do you want to execute [${props.cmd}]?').then(value -> {
					if (value == 'OK') {
						exec();
					} else {
						resolve(currentState);
					}
				}).catchError(reject);
			} else {
				exec();
			}
		});
	}
}
