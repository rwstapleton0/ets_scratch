/// Module: scripts_lab
module scripts_lab::scripts_lab {

    public struct ScriptLab has key, store {
        id: UID
    }

    public struct ScriptLabApp has key, store {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            ScriptLabApp { id: object::new(ctx) }
        );
        transfer::public_transfer(
            ScriptLab { id: object::new(ctx) },
            ctx.sender()
        );
    }

}
