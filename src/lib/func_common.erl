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

-module(func_common).

-compile(export_all).

%% 判断用户是否已经登录
is_mobile(Mobile) ->
    false.

is_email(Email) ->
    false.
is_nickname(Nickname) ->
    false.

is_uuid(Uuid) ->
    true.
