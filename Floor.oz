\insert 'Timer.oz'
\insert 'NewPortObject.oz'

fun {Floor Num Init Lifts}
   Tid = {Timer}
   Fid = {NewPortObject Init
	  fun {$ state(Called) Msg}
	     case Called
	     of notcalled then Lran in
		case Msg
		of arrive(Ack) then
		   {Browse 'Lift at floor '#Num#': open doors'}
		   {Send Tid starttimer(5000 Fid)}
		   state(doorsopen(Ack))
		[] call then
		   {Browse 'Floor '#Num#' calls a lift!'}
		   Lran = Lifts.(1+{OS.rand} mod {Width Lifts})
		   {Send Lran call(Num)}
		   state(called)
		else
  		   {Browse 'Mensaje invalido recibido :(..'}
		   state(called)
		end
	     [] called then
		case Msg
		of arrive(Ack) then
		   {Browse 'Lift at floor '#Num#': open doors'}
		   {Send Tid starttimer(5000 Fid)}
		   state(doorsopen(Ack))
		[] call then
		   state(called)
  		else
		   {Browse 'Mensaje invalido2 recibido :(..'}
		   state(called)
		end
	     [] doorsopen(Ack) then
		case Msg
		of stoptimer then
		   {Browse 'Lift at floor '#Num#': close doors'}
		   Ack=unit
		   state(notcalled)
		[] arrive(A) then
		   A=Ack
		   state(doorsopen(Ack))
		[] call then
  		   state(doorsopen(Ack))
		else
		   {Browse 'Mensaje invalido3 recibido :(..'}
		   state(called)
		end
	     else
		{Browse 'Mensaje invalido4 recibido :(..'}
		state(called)
	     end
	  end}
in Fid end
