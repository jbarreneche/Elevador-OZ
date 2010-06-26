declare FloorTravelDelta = 2000 % Tiempo en ms que tarda el ascensor entre piso y piso
        DoorOpenTime = 500 % Tiempo en ms durante el cual permanecerán las puertas abiertas

\insert 'Building.oz'

local Floors Lifts in

   {Browse 'Starting!!!'}
   
   {Building 20 1 Floors Lifts}
   {Send Floors.15 call(MovingDown)}
   {Delay 2000}
   {Send Floors.4 call(MovingUp)}
   {Delay 1000}
   {Send Floors.11 call(MovingDown)}
   {Delay 1000}
   {Send Floors.12 call(MovingDown)}
   {Delay 1000}
   {Send Floors.12 call(MovingUp)}
   {Send Floors.18 call(MovingUp)}
   {Send Floors.2 call(MovingDown)}
   {Send Floors.7 call(MovingUp)}
   {Delay 1000}
   {Send Floors.14 call(MovingUp)}
   {Send Lifts.1 press(13)}
   
   {Browse 'Finishing messages sending!'}
end
