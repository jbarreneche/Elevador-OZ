\insert 'NewPortObject2.oz'
\insert 'Button.oz'

fun {Floor Num LSys Doors} Bs = {Buttons} in
   {NewPortObject2
    proc {$ Msg}
       case Msg
       of arrive(Lid Dir Ack) then
	  {Browse 'Lift #Lid# arrived at floor'#Num}
	  {Send Doors.Lid opendoor(Ack)}
	  {Send Bs clear(Dir)}
       [] call(Dir) then
	  {Browse 'Calling lift Direction: '#Dir}
	  {Send Bs press(Dir)}
	  {Send LSys call(Num Dir)}
       end
    end}
end
		
% 	     case Called
% 	     of notcalled then Lran in
% 		case Msg
% 		of arrive(Ack) then
% 		   {Browse 'Lift at floor '#Num#': open doors'}
% 		   {Send Tid starttimer(5000 Fid)}
% 		   state(doorsopen(Ack))
% 		[] call then
% 		   {Browse 'Floor '#Num#' calls a lift!'}
% 		   Lran = Lifts.(1+{OS.rand} mod {Width Lifts})
% 		   {Send Lran call(Num)}
% 		   state(called)
% 		end
% 	     [] called then
% 		case Msg
% 		of arrive(Ack) then
% 		   {Browse 'Lift at floor '#Num#': open doors'}
% 		   {Send Tid starttimer(5000 Fid)}
% 		   state(doorsopen(Ack))
% 		[] call then
% 		   state(called)
% 		end
% 	     [] doorsopen(Ack) then
% 		case Msg
% 		of stoptimer then
% 		   {Browse 'Lift at floor '#Num#': close doors'}
% 		   Ack=unit
% 		   state(notcalled)
% 		[] arrive(A) then
% 		   A=Ack
% 		   state(doorsopen(Ack))
% 		[] call then
% 		   state(doorsopen(Ack))
%		end
%	     end
%	  end}
%end
