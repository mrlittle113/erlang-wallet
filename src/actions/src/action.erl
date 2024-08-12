-module(action).

-export([withdraw/2,
         desposit/2]).

withdraw(UserId, Money) ->
    F = fun() -> do_withdraw(UserId, Money) end,
    run_action(F).

do_withdraw(UserId, Money) ->
    TransF =
        fun(Trans) ->
            case db_wallets:get_wallet_for_update(Trans, UserId) of
                [_, CurMoney] when CurMoney >= Money ->
                    NMoney = CurMoney - Money,
                    db_wallets:update_in_trans(Trans, UserId, NMoney),
                    db_transactions:insert_in_trans(Trans, UserId, Money, withdraw),
                    ok;
                [_, _CurMoney] ->
                    {error, "Not enought money"};
                [] ->
                    {error, "Failed to perform action"}
            end
        end,   
    db_utils:trans(TransF).


desposit(UserId, Money) ->
    F = fun() -> do_desposit(UserId, Money) end,
    run_action(F).

do_desposit(UserId, Money) ->
    TransF =
        fun(Trans) ->
            case db_wallets:get_wallet_for_update(Trans, UserId) of
                [_, CurMoney] ->
                    NMoney = CurMoney + Money,
                    db_wallets:update_in_trans(Trans, UserId, NMoney),
                    db_transactions:insert_in_trans(Trans, UserId, Money, desposit),
                    ok;
                [] ->
                    {error, "Failed to perform action"}
            end
        end,   
    db_utils:trans(TransF).


run_action(Fun) ->
    Waiter = self(),

    process_flag(trap_exit, true),
    Pid = spawn_link(fun() -> Waiter ! {self(), Fun()} end),

    receive
        {Pid, Result} ->
            Result;
        {'EXIT', From, Reason} ->
            {error, "Action failed to perform", [From, Reason]}
    end.