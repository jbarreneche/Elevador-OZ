\insert 'NewPortObject2.oz'
\insert 'Buttons.oz'

fun {Floor Num LSys Doors} Bs = {Buttons} 
   fun {UpdateHistory History Dir Initial}
      call(dir:Dir.dir time:(({Property.get 'time.total'} - Initial) div 1000)) | History
   end
in 
   {NewPortObject state(waiting(up:0 down:0) nil)
    fun {$ state(Waiting History) Msg}
       case Msg
       of arrive(Lid Dir Ack) then
	  {Browse 'Lift '#Lid#'arrived at floor'#Num}
	  {Send Doors.Lid opendoor(Ack)}
	  {Send Bs clear(Dir)}
          case Waiting
          of waiting(up:0 down:_) andthen Dir == MovingUp then state(Waiting History)
          [] waiting(up:_ down:0) andthen Dir == MovingDown then state(Waiting History)
          [] waiting(up:Up down:Down) then
             if Dir == MovingUp
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
       [] call(Dir) then CDir = Dir.dir RDir = Dir.reverse.dir in
	  {Browse 'Calling lift Direction: '#CDir}
	  {Send Bs press(Dir)}
          {Send LSys call(Num Dir)}

          if Waiting.CDir == 0
          then state(waiting(CDir:{Property.get 'time.total'} RDir:Waiting.RDir) History)
          else state(Waiting History) end
                                
       [] showHistory then
          {Browse 'Floor'#Num#' History:'#History}
          state(Waiting History)
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
