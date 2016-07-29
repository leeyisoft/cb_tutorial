-module(cb_tutorial_greeting_controller, [Req]).
-compile(export_all).

index('GET', []) ->
    {ok, [
        {greeting, unicode:characters_to_binary("中文测试！", utf8, utf8)},
        {greeting2, "asdqw"},
        {greeting3, "asd"}
    ]}.
hello('GET', []) ->
    {output, "Hello, world!"}.

%% for tutorial

json('GET', []) ->
    {json, [{greeting, "hello"}]}.

list('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    % Greetings2 = [{greeting, Id, [[]|unicode:characters_to_binary(Text, utf8, utf8)]} || {greeting, Id, Text} <- Greetings],
    Greetings2 = [{greeting, Id, [[]|list_to_binary(Text)]} || {greeting, Id, Text} <- Greetings],
    {ok, [{greetings, Greetings2}]}.


create('GET', []) ->
    ok;
create('POST', []) ->
    GreetingText = Req:post_param("greeting_text"),
    NewGreeting = greeting:new(id, GreetingText),
    case NewGreeting:save() of
        {ok, SavedGreeting} ->
            {redirect, [{action, "list"}]};
        {error, ErrorList} ->
            {ok, [{errors, ErrorList}, {new_msg, NewGreeting}]}
    end.

goodbye('POST', []) ->
    boss_db:delete(Req:post_param("greeting_id")),
    {redirect, [{action, "list"}]}.

send_test_message('GET', []) ->
    TestMessage = "Free at last!",
    boss_mq:push("test-channel", TestMessage),
    {output, TestMessage}.

pull('GET', [LastTimestamp]) ->
    {ok, Timestamp, Greetings} = boss_mq:pull("new-greetings",
        list_to_integer(LastTimestamp)),
    {json, [{timestamp, Timestamp}, {greetings, Greetings}]}.

live('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    Greetings2 = [{greeting, Id, [[]|list_to_binary(Text)]} || {greeting, Id, Text} <- Greetings],
    Timestamp = boss_mq:now("new-greetings"),
    {ok, [{greetings, Greetings2}, {timestamp, Timestamp}]}.
