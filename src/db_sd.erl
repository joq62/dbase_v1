-module(db_sd).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("db_sd.hrl").

-define(TABLE,sd).
-define(RECORD,sd).

%Start Special 

get(ServiceId)->
    X=do(qlc:q([X || X <- mnesia:table(?TABLE),
		     X#?RECORD.service_id==ServiceId])),
    [XVm||{?RECORD,_XServiceId,_XVsn,_XHostId,_XVmId,XVm}<-X].

get(ServiceId,Vsn) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		     X#?RECORD.service_id==ServiceId,
		     X#?RECORD.service_vsn==Vsn])),
    [XVm||{?RECORD,_XServiceId,_XVsn,_XHostId,_XVmId,XVm}<-Z].


% End Special

create_table()->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				{type,bag}]),
    mnesia:wait_for_tables([?TABLE], 20000).
create_table(NodeList)->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				 {disc_copies,NodeList}]),
    mnesia:wait_for_tables([?TABLE], 20000).

create({?MODULE,ServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm}) ->
    create(ServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm).
create(ServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm) ->
    Record=#?RECORD{service_id=ServiceId,
		    service_vsn=ServiceVsn,
		    app_id=AppId,
		    app_vsn=AppVsn,
		    host_id=HostId,
		    vm_id=VmId,
		    vm=Vm 
		   },
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [{ServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm}||{?RECORD,ServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm}<-Z].



read(ServiceId) ->
    X=do(qlc:q([X || X <- mnesia:table(?TABLE),
		     X#?RECORD.service_id==ServiceId])),
    [{XServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm}||{?RECORD,XServiceId,ServiceVsn,AppId,AppVsn,HostId,VmId,Vm}<-X].

read(ServiceId,ServiceVsn) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		     X#?RECORD.service_id==ServiceId,
		     X#?RECORD.service_vsn==ServiceVsn])),
    [{XServiceId,XServiceVsn,AppId,AppVsn,HostId,VmId,Vm}||{?RECORD,XServiceId,XServiceVsn,AppId,AppVsn,HostId,VmId,Vm}<-Z].

delete(Id,Vsn,Vm) ->
    F = fun() -> 
		ServiceDiscovery=[X||X<-mnesia:read({?TABLE,Id}),
				     X#?RECORD.service_id==Id,
				     X#?RECORD.service_vsn==Vsn,
				     X#?RECORD.vm==Vm],
		case ServiceDiscovery of
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
