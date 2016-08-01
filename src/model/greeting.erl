-module(greeting, [Id, GreetingText]).
-compile(export_all).

validation_tests() ->
    [{fun() -> length(GreetingText) > 0 end,
        "Greeting must be non-empty!"},
     {fun() -> length(GreetingText) =< 140 end,
        "Greeting must be tweetable"}].

before_create() ->
    ModifiedRecord = set(greeting_text,
                         re:replace(GreetingText,
                                    "masticate", "chew",
                                    [{return, list}])),
    {ok, ModifiedRecord}.

%% 在 priv/init/cb_tutorial_01_news.erl 的 init/0 里面添加了监视功能功能，所以这里注释掉了
% after_create() ->
%     boss_mq:push("new-greetings", THIS).
