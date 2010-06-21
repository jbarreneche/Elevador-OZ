\insert 'NewPortObject2.oz'
\insert 'Buttons.oz'

fun {Floor Num LSys Doors} Bs = {Buttons} 
   fun {UpdateHistory History Dir Initial} Result in
      Result = call(dir:Dir time:({Property.get 'time.total'} - Initial)) | History
      {Browse Result}
      Result
   end
in 
   {NewPortObject state(waiting(up:0 down:0) nil)
    fun {$ state(Waiting History) Msg}
       case Msg
       of arrive(Lid Dir Ack) then
	  {Browse 'Lift #Lid# arrived at floor'#Num}
	  {Send Doors.Lid opendoor(Ack)}
	  {Send Bs clear(Dir)}
          case Waiting
          of waiting(up:0 down:_) andthen Dir == up then state(Waiting History)
          [] waiting(up:_ down:0) andthen Dir == down then state(Waiting History)
          [] waiting(up:Up down:Down) then
             if Dir == up
             then state(waiting(up:0 down:Down) {UpdateHistory History Dir Up})
             else state(waiting(up:Up down:0) {UpdateHistory History Dir Down})
             end
          end
       [] leaving(Dir) then
	  {Send Bs clear(Dir)}
          case Waiting
          of waiting(up:0 down:_) andthen Dir == up then state(Waiting History)
          [] waiting(up:_ down:0) andthen Dir == down then state(Waiting History)
          [] waiting(up:Up down:Down) then
             if Dir == up
             then state(waiting(up:0 down:Down) {UpdateHistory History Dir Up})
             else state(waiting(up:Up down:0) {UpdateHistory History Dir Down})
             end
          end
       [] call(Dir) then
	  {Browse 'Calling lift Direction: '#Dir}
	  {Send Bs press(Dir)}
          {Send LSys call(Num Dir)}
          case Waiting
          of waiting(up:0 down:D) andthen Dir == up then state(waiting(up:{Property.get 'time.total'} down:D) History)
          [] waiting(up:U down:0) andthen Dir == down then state(waiting(up:U down:{Property.get 'time.total'}) History)
          else state(Waiting History)
          end
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
