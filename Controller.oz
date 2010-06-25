\insert 'NewPortObject.oz'
\insert 'Timer.oz'

declare Controller

fun {Controller Init} Tid={Timer} Cid in
   Cid = {NewPortObject Init
	  fun {$ state(Motor F Lid) Msg}
	     case Motor
	     of running then
		case Msg
		of stoptimer then
		   {Send Lid 'at'(F)}
		   state(stopped F Lid)
		end
	     [] stopped then
		case Msg
		of step(Dest) then
		   if F == Dest then
		      state(stopped F Lid)
		   elseif F < Dest then
		      {Send Tid starttimer(FloorTravelDelta Cid)}
		      state(running F+1 Lid)
		   else % F > Dest
		      {Send Tid starttimer(FloorTravelDelta Cid)}
		      state(running F-1 Lid)
		   end
		end
	     end
	  end}
end
