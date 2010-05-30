declare EmptySchedule Reschedule RemoveFirst NextFrom

fun {EmptySchedule}
   schedule(nil nil)
end

fun {RemoveFirst schedule(Up Down) Dir}
   if Dir == up then schedule(Up.2 Down)
   else schedule(Up Down.2) end
end

fun {NextFrom schedule(Up Down) Dir}
   case if Dir == up then Up
	else Down end
   of nil then nil
   [] H|T then H
   end
end
   
      
fun {Reschedule schedule(Up Down) Current NewFloor}
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
in
   if NewFloor > Current
   then schedule({AscendingAdd Up NewFloor} Down)
   else schedule(Up {DescendingAdd Down NewFloor})
   end
end

% local S1 S2 S3 S4 in
%    S1 = {EmptySchedule}
%    S2 = {Reschedule {Reschedule S1 3 6} 3 4}
%    {Browse {Reschedule {Reschedule {Reschedule S2 3 7} 3 2} 3 2}}
% end
%{Browse up == up}