-module(db_service_def).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("db_service_def.hrl").



-define(TABLE,service_def).
-define(RECORD,service_def).

create_table()->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				{type,bag}]),
    mnesia:wait_for_tables([?TABLE], 20000).
create_table(NodeList)->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				 {disc_copies,NodeList}]),
    mnesia:wait_for_tables([?TABLE], 20000).

create({?MODULE,ServiceId,ServiceVsn,StartCmd,GitPath})->
    create(ServiceId,ServiceVsn,StartCmd,GitPath).
create(ServiceId,ServiceVsn,StartCmd,GitPath)->
    Record=#?RECORD{ service_id=ServiceId,
		     service_vsn=ServiceVsn,
		     start_cmd=StartCmd,
		     gitpath=GitPath},
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [{ServiceId,ServiceVsn,StartCmd,GitPath}||{?RECORD,ServiceId,ServiceVsn,StartCmd,GitPath}<-Z].



read(ServiceId) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		   X#?RECORD.service_id==ServiceId])),
    [{XServiceId,ServiceVsn,StartCmd,GitPath}||{?RECORD,XServiceId,ServiceVsn,StartCmd,GitPath}<-Z].

read(ServiceId,ServiceVsn) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		     X#?RECORD.service_id==ServiceId,
		     X#?RECORD.service_vsn==ServiceVsn])),
    [{XServiceId,XServiceVsn,StartCmd,GitPath}||{?RECORD,XServiceId,XServiceVsn,StartCmd,GitPath}<-Z].

update(Id,Vsn,NewVsn,NewGitPath) ->
    F = fun() -> 
		ServiceDef=[X||X<-mnesia:read({?TABLE,Id}),
			    X#?RECORD.service_id==Id,X#?RECORD.service_vsn==Vsn],
		case ServiceDef of
		    []->
			mnesia:abort(?TABLE);
		    [S1]->
			mnesia:delete_object(S1), 
			mnesia:write(#?RECORD{service_id=Id,service_vsn=NewVsn,gitpath=NewGitPath})
		end
	end,
    mnesia:transaction(F).

delete(Id,Vsn) ->

    F = fun() -> 
		ServiceDef=[X||X<-mnesia:read({?TABLE,Id}),
			    X#?RECORD.service_id==Id,X#?RECORD.service_vsn==Vsn],
		case ServiceDef of
		    []->
			mnesia:abort(?TABLE);
		    [S1]->
			mnesia:delete_object(S1) 
		end
	end,
    mnesia:transaction(F).


do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

%%-------------------------------------------------------------------------
