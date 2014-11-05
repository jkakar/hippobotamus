-module(hippo_tests).

-include_lib("eunit/include/eunit.hrl").

hippo_test_() ->
    {setup,
     fun() ->
             ok
     end,
     fun(_) ->
             ok
     end,
     [
      {"hippo is alive",
       fun() ->
               %% format is always: expected, actual
               ?assertEqual(howdy, hippo:hello())
       end}
      ]}.

