%%%-------------------------------------------------------------------
%%% File    : ip_loc_macro.erl
%%% Author  : alvin <>
%%% Description : 
%%%
%%% Created :  7 Aug 2008 by alvin <>
%%%-------------------------------------------------------------------
-module(ip_loc_macro).

%% API
-export([gen_ip2icp_bin/0]).

%%====================================================================
%% API
%%====================================================================
gen_ip2icp_bin() ->
    Dir = "ipdb",
    {ok, Filenames} = file:list_dir(Dir),
    GenFun = fun(File) ->
                     Ext = filename:extension(File),
                     if Ext =:= ".db" -> gen_ip2icp_bin(Dir,File);
                        true -> [] end
             end,
                     
    Defines = lists:map(GenFun,Filenames),
    Tail = "ip2icp_bin(_)-> {\"Unknown\",\"Unknown\"}.",
    io:format("~s", [lists:flatten([Defines,Tail])]),
    halt(0).

gen_ip2icp_bin(Dir,File) ->
    {ok, BinData} = file:read_file(filename:join(Dir,File)),
    Data = binary_to_list(BinData),
    Lines = string:tokens(Data,"\r\n"),
    
    GenDef = fun(Line) -> gen_ip2icp_def(Line,filename:rootname(File)) end,
    lists:map(GenDef,Lines).

gen_ip2icp_def(Line,Icp) ->
    [IpStr,MaskStr] = string:tokens(Line,"/"),
    {ok,{A,B,C,D}} = inet_parse:address(IpStr),
    Mask = list_to_integer(MaskStr),
    <<Seg:Mask/bits,_Zero/bits>> = <<A,B,C,D>>,
    SegStr = io_lib:write(Seg),
    SegStart = string:strip(SegStr,right,$>),
    io_lib:format(
      "ip2icp_bin(~s,_/bits>>) -> {\"~s\",\"~s\"};~n",
      [SegStart,Icp,Line]).

%%--------------------------------------------------------------------
%%--------------------------------------------------------------------

%%====================================================================
%% Internal functions
%%====================================================================
