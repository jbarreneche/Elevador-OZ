declare EmptySchedule Reschedule
fun {EmptySchedule}
   schedule(nil nil)
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
