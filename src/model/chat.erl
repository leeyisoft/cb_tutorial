-module(chat, [Id, Channel, Nickname, Text, CreateTime]).

-compile(export_all).

validation_tests() ->
    [
        {fun() -> length(Nickname) > 2 end, "Nickname must be not less than 2 characters! "},
        {fun() -> length(Nickname) =< 45 end, "Nickname must be not more than 45 characters! "},
        {fun() -> length(Text) > 0 end, "text must be non-empty! "},
        {fun() -> length(Text) =< 140 end, "text must be tweetable"}
    ].

before_create() ->
    ModifiedRecord = set(row,
                         re:replace(Text,
                                    "masticate", "chew",
                                    [{return, list}])),
    {ok, ModifiedRecord}.

after_create() ->
    boss_mq:push("chats", THIS).
