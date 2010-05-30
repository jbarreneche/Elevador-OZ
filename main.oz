\insert 'Building.oz'

local Floors Lifts in

   {Browse 'Starting!!!'}
   
   {Building 20 1 Floors Lifts}
   {Send Floors.20 call}
   {Send Floors.4 call}
   {Send Floors.10 call}
   %{Send Lifts.1 call(4)}
   
   {Browse 'Finishing messages sending!'}

end
