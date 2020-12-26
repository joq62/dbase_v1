%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(init_tables). 
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%%---------------------------------------------------------------------
%% Records for test
%%
-define(InitFile,"./test_src/table_info.hrl").

%% --------------------------------------------------------------------

-export([start/0]).

%% ====================================================================
%% External functions
%% ====================================================================
init_table()->
    {ok,Info}=file:consult(?InitFile),
    dbase:init_table_info(Info),
   
    ?assertEqual(["c2","c1","c0"],
		 mnesia:dirty_all_keys(server)),
    ?assertEqual([],
		 mnesia:dirty_all_keys(deployment)),
    ?assertEqual(["test_1"],
		 mnesia:dirty_all_keys(deployment_spec)),
    ?assertEqual(["joq62"],
		 mnesia:dirty_all_keys(passwd)),
    ?assertEqual([],
		 mnesia:dirty_all_keys(sd)),
    ?assertEqual(["adder_service","common","divi_service","multi_service"],
		 mnesia:dirty_all_keys(service_def)),
    ?assertEqual(["server_0","server_1","server_2","calc"],
		 mnesia:dirty_all_keys(app_spec)),
    ok.


% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start()->
    %initiate table 
    ?assertEqual(ok,init_table()),
    
    ?debugMsg("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
   
    ok.
