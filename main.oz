\insert 'Building.oz'

local Floors Lifts in

   {Browse 'Starting!!!'}
   
   {Building 20 1 Floors Lifts}
   {Send Floors.15 call(down)}
   {Delay 10}
   %%{Send Floors.4 call(up)}
   %%{Delay 1}
   %%{Send Floors.11 call(down)}
   %%{Delay 1}
   %%{Send Floors.12 call(down)}
   %%{Delay 1}
   {Send Floors.8 call(down)}
   %%{Delay 1}
   %%{Send Floors.14 call(up)}
   %% {Send Lifts.1 call(4)}
   
   {Browse 'Finishing messages sending!'}
   %% {Browse Floors.4}
end


%% {Browse []}
%% local S = smartSchedule(current:schedule(1 2) future:schedule(3 4)) T = current in
%%   {Browse S}
%%   {Browse S.future}
%%   {Browse S.T}
%% end
%% local S1 = s(u:1 t:2) S2 = s(t:2 u:1) in
%%   case S1
%%   of nil then {Browse "Rockero!"}
%%   else
%%      {Browse S1}
%%      {Browse S2}
%%   end
%%end
      
