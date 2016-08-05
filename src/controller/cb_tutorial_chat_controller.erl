-module(cb_tutorial_chat_controller, [Req]).
-compile(export_all).


%% 提交表单
create('POST', []) ->
    Channel    = "chats",
    Nickname   = Req:post_param("nickname"),
    Text       = Req:post_param("text"),
    CreateTime = calendar:datetime_to_gregorian_seconds(erlang:universaltime()),
    NewChat    = chat:new(id, Channel, Nickname, Text, CreateTime),
    case NewChat:save() of
        {ok, SavedChat} ->
            {json, [{code, 0}, {msg, SavedChat}]};
        {error, ErrorList} ->
            {json, [{code, 3}, {msg, list_to_bitstring(ErrorList)}]}
    end.

%% 删除数据
delete('POST', []) ->
    ChartId = Req:post_param("chat_id"),
    Chat    = boss_db:find(chat, [{id, 'equals', ChartId}]),
    [Chat1] = Chat,
    boss_db:delete(ChartId),
    boss_mq:push("delchat", Chat1),
    {json, [{chat_id, ChartId}]}.

%% 拉取数据
pull('GET', [Channel, LastTimestamp]) ->
    {ok, Timestamp, Chats} = boss_mq:pull(Channel, list_to_integer(LastTimestamp)),

    Chats2 = [{chat, Id, Channel, Nickname, Text, erlydtl_dateformat:format(calendar:gregorian_seconds_to_datetime(CreateTime), "Y-m-d H:i:s")} || {chat, Id, Channel, Nickname, Text, CreateTime} <- Chats],

    {json, [{timestamp, Timestamp}, {chats, Chats2}]}.

%% 聊天室界面
we_are_come_to_chat('GET', []) ->

    % 限制聊天记录显示条数
    Limit = 40,

    Chats  = boss_db:find(chat, [], [{limit, Limit}, {order_by, 'id'}, descending]),

    % 处理输入时间，和中文字符
    Chats2 = [{chat, Id, Channel, Nickname, [[]|unicode:characters_to_binary(Text, utf8, utf8)], calendar:gregorian_seconds_to_datetime(CreateTime)} || {chat, Id, Channel, Nickname, Text, CreateTime} <- Chats],

    Timestamp = boss_mq:now("chats"),
    {ok, [{chats, Chats2}, {timestamp, Timestamp}, {limit, Limit}]}.

%% 聊天记录列表
list('GET', [Channel, CurPage]) ->
    Curpage = list_to_integer(CurPage),

    PerPage = 20,

    if
        Curpage > 1 ->
            Offset = PerPage*(Curpage-1);
        true ->
            Offset = 0
    end,
    Options    = [{limit, PerPage}, {offset, Offset}, {order_by, 'id'}, descending],

    Conditions = [{channel, 'equals', Channel}],

    Count      = boss_db:count(chat, Conditions),

    Chats      = boss_db:find(chat, Conditions, Options),
    Pages      = lists:seq(1, (Count div PerPage)+1),
    Chats2     = [{chat, Id, Channel, Nickname, [[]|unicode:characters_to_binary(Text, utf8, utf8)], calendar:gregorian_seconds_to_datetime(CreateTime)} || {chat, Id, Channel, Nickname, Text, CreateTime} <- Chats],

    {ok, [{channel, Channel}, {count, Count}, {perpage, PerPage}, {curpage, Curpage}, {action, "/chat/list/chats/"}, {pages, Pages}, {chats, Chats2}]}.
