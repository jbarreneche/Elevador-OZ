\insert 'Building.oz'

local Floors Lifts in

   {Browse 'Starting!!!'}
   
   {Building 20 1 Floors Lifts}
   {Send Floors.20 call(down)}
   {Delay 1}
   {Send Floors.4 call(up)}
   {Delay 1}
   {Send Floors.11 call(down)}
   {Delay 1}
   {Send Floors.12 call(down)}
   {Delay 1}
   {Send Floors.8 call(up)}
   {Delay 1}
   {Send Floors.14 call(up)}
   {Send Lifts.1 call(4)}
   
   {Browse 'Finishing messages sending!'}
   %% {Browse Floors.4}
end


%% {Browse []}
