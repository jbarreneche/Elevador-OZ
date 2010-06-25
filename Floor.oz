\insert 'NewPortObject2.oz'
\insert 'Buttons.oz'

fun {Floor Num LSys Doors} Bs = {Buttons} 
   fun {UpdateHistory History Dir Initial}
      call(dir:Dir time:(({Property.get 'time.total'} - Initial) div 1000)) | History
   end
   fun {EndWait Dir Waiting History} CDir = Dir.dir RDir = Dir.reverse.dir in
      if Waiting.CDir == 0 then state(Waiting History)
      else state(waiting(CDir:0 RDir:Waiting.RDir) {UpdateHistory History CDir Waiting.CDir})
      end
   end
in 
   {NewPortObject state(waiting(up:0 down:0) nil)
    fun {$ state(Waiting History) Msg}
       case Msg
       of arrive(Lid Dir Ack) then
	  {Browse 'Lift '#Lid#'arrived at floor'#Num}
	  {Send Doors.Lid opendoor(Ack)}
	  {Send Bs clear(Dir)}
          {EndWait Dir Waiting History}
       [] leaving(Dir) then
	  {Send Bs clear(Dir)}
          {EndWait Dir Waiting History}
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
