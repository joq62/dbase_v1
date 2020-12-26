%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(table_test). 
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").

%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------

-export([start/0]).

%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start()->
    %initiate table 
    ?assertEqual(ok,check_tables()),

    ?debugMsg("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
   
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
check_tables()->
    ?assertEqual([{"server_0","1.0.0",
		   [{host,"c0"},{vm_id,"server_100"},{vm_dir,"server_100"}],
		   [{"common","1.0.0"},{"dbase","1.0.0"},{"server","1.0.0"}]},
		  {"server_1","1.0.0",
		   [{host,"c1"},{vm_id,"server_100"},{vm_dir,"server_100"}],
		   [{"common","1.0.0"},{"dbase","1.0.0"},{"server","1.0.0"}]},
		  {"server_2","1.0.0",
		   [{host,"c2"},{vm_id,"server_100"},{vm_dir,"server_100"}],
		   [{"common","1.0.0"},{"dbase","1.0.0"},{"server","1.0.0"}]},
		  {"calc","1.0.0",
		   [],
		   [{"adder_service","1.0.0"},{"multi_service","1.0.0"},{"divi_service","1.0.0"}]}],if_db:app_spec_read_all()),
    
    ok.
