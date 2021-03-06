%%%-------------------------------------------------------------------
%%% File    : ip_loc.erl
%%% Author  : alvin <>
%%% Description : 
%%%
%%% Created :  7 Aug 2008 by alvin <>
%%%-------------------------------------------------------------------
-module(ip_loc).

%% API
-export([ip2icp/1]).

-compile({parse_transform, emp2}).

-macro({ip_loc_macro, gen_ip2icp_bin, []}).

%%====================================================================
%% API
%%====================================================================
ip2icp({A,B,C,D}) ->
    Bin = <<A,B,C,D>>,
    ip2icp_bin(Bin).
    
%%--------------------------------------------------------------------
%%--------------------------------------------------------------------

%%====================================================================
%% Internal functions
%%====================================================================
