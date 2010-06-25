declare FloorTravelDelta = 4000 % Tiempo en ms que tarda el ascensor entre piso y piso
        DoorOpenTime = 500 % Tiempo en ms durante el cual permanecerán las puertas abiertas
\insert 'Movement.oz'
\insert 'Building.oz'

local Floors Lifts in

   {Browse 'Starting!!!'}
   
   {Building 20 1 Floors Lifts}
   {Send Floors.15 call(MovingDown)}
   {Delay 2000}
   %%{Send Floors.4 call(MovingUp)}
   %%{Delay 1}
   %%{Send Floors.11 call(MovingDown)}
   %%{Delay 1}
   %%{Send Floors.12 call(MovingDown)}
   %%{Delay 1}
   {Send Floors.12 call(MovingUp)}
   {Send Floors.18 call(MovingUp)}
   {Send Floors.2 call(MovingDown)}
   {Send Floors.7 call(MovingUp)}
   %%{Delay 1}
   %%{Send Floors.14 call(MovingUp)}
   %% {Send Lifts.1 call(4)}
   
   {Browse 'Finishing messages sending!'}
   %% {Browse Floors.4}
end

% {Browse  100 div 15}
%% {Browse []}
%% local S = smartSchedule(current:schedule(1 2) future:schedule(3 4)) T = current in
%%   {Browse S}
%%   {Browse S.future}
%%   {Browse S.T}
%% end
%% local S1 = s(u:1 t:2) S2 = s(t:2 u:1) in
%%   case S1
%%   of nil then {Browse "Rockero!"}.
%%   else
%%      {Browse S1}
%%      {Browse S2}
%%   end
%%end
      
%{Browse s(1 2)}
%local A = s(1) in
%   case A
%   of C = _(S) then {Browse 'yaho!'}
%   else {Browse 'bummer...'}
%   end
%end
