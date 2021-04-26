package;

using api.IdeckiaCmdApi;
typedef Props = {
    @:editable("Path to the command")
    var cmd:String;
    @:editable("Arguments for the command")
    var ?args:Array<String>;
}

class Command extends IdeckiaCmd {

	public function execute():ItemState {
        var status = Sys.command(props.cmd, props.args);
        if (status != 0) {
            var args = (props.args == null) ? '' : props.args.join(' ');
            server.log.error('Something went wrong (status=$status) executing [${props.cmd} ${args}]');
        }
        return state;
	}
}