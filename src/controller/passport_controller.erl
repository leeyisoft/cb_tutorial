%% -----------------------------------------------------------------------------
%% Copyright © 2016-2020 leeyi
%%
%% desc2
%%
%% desc2
%%
%% You should have received a copy of the GNU Lesser General Public
%% License along with Erlang UUID.  If not, see
%% <http://www.gnu.org/licenses/>.
%% -----------------------------------------------------------------------------
%% @author leeyi <leeyisoft@qq.com>
%% @copyright 2016-2020 leeyi
%% @doc
%% 用户登录注册等功能
%%
%%
%% @end
%% @reference See <a href="">See</a>
%%            for more information.
%% -----------------------------------------------------------------------------

-module(passport_controller, [Req, SessionId]).
% -module(passport_controller).

-compile(export_all).

index('GET', []) ->
    % {json, [{code,0}, {msg, "hello"}]}.
    case func_member:is_login({test, SessionId}) of
        true ->
            {json, [{code, 0}, {msg, "member_is_login"}]};
        false ->
            % {redirect, [{action, "login"}]}
            {json, [{code, 0}, {sid, SessionId}]}
    end.

%% 登录页面
login('GET', []) ->
    % {redirect, [{controller, "chat"}, {action, "we_are_come_to_chat"}]};
    {ok, [{limit, 5}]};

login('POST', []) ->
    LoginId    = Req:post_param("login_id"),
    Password   = Req:post_param("password"),

    IsEmail    = func_common:is_email(LoginId),
    IsMobile   = func_common:is_mobile(LoginId),
    IsNickname = func_common:is_nickname(LoginId),
    Conditions = if
        IsEmail ->
            [{email, LoginId}];
        IsMobile ->
            [{mobile, LoginId}];
        IsNickname ->
            [{nickname, LoginId}];
        true ->
            % {json, [{code, 1} , {msg, "Illegal operation."}]}
            % [{nickname, LoginId}, {password, Password}]
            [{nickname, LoginId}]
    end,
    % Conditions = if
    %     true ->
    %         [{email, LoginId}, {password, Password}];
    %     false ->
    %         [{nickname, LoginId}, {password, Password}]
    % end,

    Member = boss_db:find(member, Conditions),

    [{member, _Id, Uuid, Nickname, Email, Mobile, Encrypt_pwd, Sold, _, _, _, _,_,_ }] = Member,
    Encrypt_pwd_input = func_member:encrypt_pwd(Password, Sold),


    {json, [{code, 0}, {pwd, Encrypt_pwd}, {pwd_input, Encrypt_pwd_input}, {member, Member}]}.
    % [{member,"member-1",
    %      <<"e949f8a-5d42-11e6-9e4e-a45e60bb8fad">>,<<"leeyi">>,
    %      undefined,undefined,<<"123456">>,
    %      <<"e949f8a-5d42-11e6-9e4e-a45e60bb8fad">>,0,undefined,0,
    %      undefined,0,<<"hello">>}]
    % case Member of
    %     [{member, _Id, Uuid, Nickname, Email, Mobile, Password, Sold,
    %         LoginLastTime, LoginLastIp, RegTime, RegIp, LoginTimes,
    %         Signature}|_] ->
    %     io:format("Cid: ~p~n", [Member]),
    %     % Hash = app_cp:login_key_rule(integer_to_list(Cid),UserName,PassWord),
    %     % boss_session:set_session_data(SessionId, "session_cid", integer_to_list(Cid)),
    %     % boss_session:set_session_data(SessionId, "session_account", UserName),
    %     % boss_session:set_session_data(SessionId, "session_password", PassWord),
    %     % boss_session:set_session_data(SessionId, "session_hash", Hash),
    %     {redirect, [{controller, "chat"}, {action, "we_are_come_to_chat"}]};
    %     _Ca ->
    %     io:format("_Ca: ~p~n", [_Ca]),
    %     {redirect, [{controller, "passport"}, {action, "login"}]}
    % end.
