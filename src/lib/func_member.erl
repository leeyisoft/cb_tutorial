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

-module(func_member).

-compile(export_all).

%% 判断用户是否已经登录
is_login({test, SessionId}) ->
    % Cid     = boss_session:get_session_data(SessionId, "sess_uuid"),
    % Account = boss_session:get_session_data(SessionId, "sess_nickname"),
    % Passwd  = boss_session:get_session_data(SessionId, "sess_salt"),
    % Hash    = login_key_rule(Cid, Account, Passwd),
    % SHash =:= Hash;
    true;
is_login({uid, Uid}) ->
    true;
is_login({uuid, Uuid}) ->
    true;
is_login({email, Email}) ->
    true;
is_login({moible, Mobile}) ->
    true;
is_login({nickname, Nickname}) ->
    true.

login({uid, Uid, Pwd, Salt}) ->
    true;
login({uuid, Uuid, Pwd, Salt}) ->
    true;
login({email, Email, Pwd, Salt}) ->
    true;
login({moible, Mobile, Pwd, Salt}) ->
    true;
login({nickname, Nickname, Pwd, Salt}) ->
    true.
login_after(Memberinfo) ->
    true.

%% 密码加密函数
%%--------------------------------------------------------------------
%% Function: encrypt_pwd(Password, Salt)
%%           Password = string(), 账户密码密码名为
%%           Salt     = string(), salt
%% Descrip.: Perform MySQL authentication.
%% Returns : Returns the length of 40 string
%% Example : func_member:encrypt_pwd("123456", "e949f8a-5d42-11e6-9e4e-a45e60bb8fad").
%%          return "84d11081dee3fec2e341be57be04e651d6080e65"
%%--------------------------------------------------------------------
%% @doc
%% func_member:encrypt_pwd("123456", "e949f8a-5d42-11e6-9e4e-a45e60bb8fad").
%% "84d11081dee3fec2e341be57be04e651d6080e65"
%% @end
%%--------------------------------------------------------------------
encrypt_pwd([], _Salt) ->
    <<>>;
encrypt_pwd(Password, Salt) ->
    Stage1 = crypto:hash(sha, Password),
    Stage2 = crypto:hash(sha, Stage1),
    Res    = crypto:hash_final(crypto:hash_update(
                crypto:hash_update(crypto:hash_init(sha), Salt),
                Stage2
            )),
    lists:flatten(list_to_hex(binary_to_list(Res))).

%%--------------------------------------------------------------------
%% Private
%%--------------------------------------------------------------------
login_key_rule(Cid, Account, Passwd) when Cid =:= undefined; Account =:= undefined; Passwd =:= undefined ->
    "";
login_key_rule(Cid, Account, Passwd) ->
    io:format("Cid: ~p~n", [Cid]),
    io:format("Account: ~p~n", [Account]),
    io:format("Passwd: ~p~n", [Passwd]),
    crypto:hash(sha, Cid ++ Account ++ Passwd).

%% Convert Integer from the SHA to Hex
list_to_hex(L)->
    lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
       [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
       $0+N;
hex(N) when N >= 10, N < 16 ->
       $a + (N-10).
