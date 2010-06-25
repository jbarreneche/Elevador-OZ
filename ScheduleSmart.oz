declare EmptySchedule Reschedule RemoveFirst NextFrom

local
   fun {IsEmpty schedule(up:Up down:Down)} Up == nil andthen Down == nil end
   fun {EmptyPair} schedule(up:nil down:nil) end
   fun {Reverse Dir}
      case Dir
      of up then down
      [] down then up
      else Dir end
   end
   fun {TailPair Schedule Dir} RDir = {Reverse Dir} in
      schedule(Dir:Schedule.Dir.2 RDir:Schedule.RDir)
   end
in
   fun {EmptySchedule}
      smart(current:{EmptyPair} future:{EmptyPair})
   end
   fun {RemoveFirst smart(current:Current future:Future) Dir}
      if Current.Dir == nil then
         if {IsEmpty Current}
         then smart(current:Future future:{EmptyPair})
         else smart(current:Current future:Future)
         end
      else
         smart(current:{TailPair Current Dir} future:Future)
      end
   end
   fun {NextFrom smart(current:Current future:Future) Dir}
      case Current.Dir
      of nil then nil
      [] H|T then H
      end
   end
end

fun {Reschedule smart(current:Current future:Future) CFloor CDir NFloor NDir}
   fun{Add Pred List Value}
      case List
      of nil then [Value]
      [] H|T andthen H == Value then List
      [] H|T andthen {Pred H Value} then H|{Add Pred T Value}
      else Value|List
      end
   end
   fun {AscendingAdd List Value} {Add fun{$ A B} A < B end List Value} end
   fun {DescendingAdd List Value} {Add fun{$ A B} A > B end List Value} end
   fun {MovingFromTo Origin Destination}
      if Origin < Destination then up
      else down end
   end
   fun {SameDirection CFloor NFloor Direction}
      {MovingFromTo CFloor NFloor} == Direction
   end
   fun {AddToSchedule schedule(up:Up down:Down) Floor Dir}
      if Dir == up
      then schedule(up:{AscendingAdd Up Floor} down:Down)
      else schedule(up:Up down:{DescendingAdd Down Floor})
      end
   end
in
   if (CDir == NDir) andthen {SameDirection CFloor NFloor NDir}
   then smart(current:{AddToSchedule Current NFloor NDir} future:Future)
   else smart(current:Current future:{AddToSchedule Future NFloor NDir})
   end
end

% local S1 S2 S3 S4 in
%    S1 = {EmptySchedule}
%    S2 = {Reschedule {Reschedule S1 3 6} 3 4}
%    {Browse {Reschedule {Reschedule {Reschedule S2 3 7} 3 2} 3 2}}
% end
%{Browse up == up}
