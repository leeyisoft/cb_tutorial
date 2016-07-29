-module(chat, [Id, Row]).

-compile(export_all).

validation_tests() ->
    [
        {fun() -> length(Row) > 0 end, "text must be non-empty!"},
        {fun() -> length(Row) =< 140 end, "text must be tweetable"}
    ].

before_create() ->
    ModifiedRecord = set(row,
                         re:replace(Row,
                                    "masticate", "chew",
                                    [{return, list}])),
    {ok, ModifiedRecord}.

after_create() ->
    boss_mq:push("new-chats", THIS).
