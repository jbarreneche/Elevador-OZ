\insert 'Timer.oz'
\insert 'NewPortObject.oz'
declare Florr
fun {Floor Num Init Lifts}
   Tid = {Timer}
   Fid = {NewPortObject Init
	  fun {$ Msg state(Called)}
	     case Called
	     of notcalled then Lran in
		case Msg
		of arrive(Ack) then
		   {Browse 'Lift at floor '#Num#': open doors'}
		   {Send Tid stattimer(5000 Fid)}
		   state(doorsopen(Ack))
		[] call then
		   {Browse 'Floor '#Num#' calls a lift!'}
		   Lran = Lifts.(1+(OS.rand) mod {Width Lifts})
		   {Send Lran call(Num)}
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
		end
	     end
	  end}
in Fid end
