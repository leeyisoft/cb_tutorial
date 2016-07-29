-module(cb_tutorial_chat_controller, [Req]).
-compile(export_all).


create('POST', []) ->
    Nickname = Req:post_param("nickname"),
    Text = Req:post_param("text"),
    NewChat = chat:new(id, Nickname++":"++Text),
    case NewChat:save() of
        {ok, SavedChat} ->
            {json, [{code, 0}, {msg, SavedChat}]};
        {error, ErrorList} ->
            {json, [{code, 3}, {msg, ErrorList}]}
    end.


pull('GET', [LastTimestamp]) ->
    {ok, Timestamp, Chats} = boss_mq:pull("new-chats",
        list_to_integer(LastTimestamp)),
    {json, [{timestamp, Timestamp}, {chats, Chats}]}.

we_are_come_to_chat('GET', []) ->
    Chats = boss_db:find(chat, []),
    Chats2 = [{chat, Id, [[]|list_to_binary(Row)]} || {chat, Id, Row} <- Chats],
    Timestamp = boss_mq:now("new-chats"),
    {ok, [{chats, lists:reverse(lists:sort(Chats2))}, {timestamp, Timestamp}]}.
