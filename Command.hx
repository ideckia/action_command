package;

import js.node.ChildProcess;

using api.IdeckiaApi;

typedef Props = {
	@:editable("prop_command")
	var command:String;
	@:editable("prop_args")
	var ?args:Array<String>;
	@:editable("prop_confirm", false)
	var ?confirm:Bool;
	@:editable("prop_detached", true)
	var ?detached:Bool;
}

@:name('command')
@:description('action_description')
@:localize
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
						showResponse(Loc.command_output.tr([currentState.text]), data, false);

					resolve(new ActionOutcome({state: currentState}));
				});
				var error = '';
				cmd.stderr.on('data', e -> {
					error += e;
				});
				cmd.stderr.on('end', e -> {
					if (error != '') {
						showResponse(Loc.command_error.tr([currentState.text]), error, true);
						reject(error);
					}
				});
			}

			if (props.confirm) {
				core.dialog.question(Loc.are_you_sure.tr(), Loc.do_you_want_execute.tr([props.command])).then(isOk -> {
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
				core.dialog.error(title, response);
			else
				core.dialog.info(title, response);
		} else {
			var text = lines.shift();
			core.dialog.list(title, text, text, lines);
		}
	}
}
