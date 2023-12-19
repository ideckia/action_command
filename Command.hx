package;

import js.node.ChildProcess;

using api.IdeckiaApi;

typedef Props = {
	@:editable("Path to the command")
	var command:String;
	@:editable("Arguments for the command")
	var ?args:Array<String>;
	@:editable("Does it need confirmation?", false)
	var ?confirm:Bool;
	@:editable("Run the command and don't wait for any response?", true)
	var ?detached:Bool;
}

@:name('command')
@:description('Executes system command with given parameters')
class Command extends IdeckiaAction {
	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			function exec() {
				var options:ChildProcessSpawnOptions = {
					shell: true
				}

				if (props.detached) {
					options.detached = true;
					options.stdio = Ignore;
				}

				var cmd = if (props.args != null && props.args.length > 0) {
					ChildProcess.spawn(props.command, props.args, options);
				} else {
					ChildProcess.spawn(props.command, options);
				}

				if (props.detached) {
					cmd.unref();
					resolve(new ActionOutcome({state: currentState}));
					return;
				}

				var data = '';
				cmd.stdout.on('data', e -> {
					data += e;
				});
				cmd.stdout.on('end', e -> {
					if (data != '')
						showResponse('Command [${currentState.text}] output', data, false);

					resolve(new ActionOutcome({state: currentState}));
				});
				var error = '';
				cmd.stderr.on('data', e -> {
					error += e;
				});
				cmd.stderr.on('end', e -> {
					if (error != '') {
						showResponse('Command [${currentState.text}] error', error, true);
						reject(error);
					}
				});
			}

			if (props.confirm) {
				server.dialog.question('Are you sure?', 'Do you want to execute [${props.command}]?').then(isOk -> {
					if (isOk) {
						exec();
					} else {
						resolve(new ActionOutcome({state: currentState}));
					}
				}).catchError(reject);
			} else {
				exec();
			}
		});
	}

	function showResponse(title:String, response:String, isError:Bool) {
		var lines = response.split('\n').filter(e -> e != '');
		if (lines.length == 1) {
			if (isError)
				server.dialog.error(title, response);
			else
				server.dialog.info(title, response);
		} else {
			var text = lines.shift();
			server.dialog.list(title, text, text, lines);
		}
	}
}
