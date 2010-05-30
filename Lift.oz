\insert 'NewPortObject.oz'
\insert 'ScheduleSmart.oz'

declare Lift

fun {Lift Num Init Cid Floors}
   fun {ReverseMoving Moving}
      if Moving == notmoving then notmoving
      elseif Moving == up then down
      else up end
   end
   fun {MovingFromTo Origin Destination}
      if Origin < Destination then up
      else down end
   end
in
   {NewPortObject Init
    fun {$ state(Pos Sched Moving) Msg}
       case Msg
       of call(N) then
	  {Browse 'Lift '#Num#' needed at floor '#N}
	  if (N == Pos) andthen (Moving == notmoving) then
	     {Wait {Send Floors.Pos arrive(Num up $)}}
	     state(Pos Sched notmoving)
	  else Sched2 = {Reschedule Sched Pos N} in
	     if Moving == notmoving then {Send Cid step(N)} end
	     state(Pos Sched2 {MovingFromTo Pos N})
	  end
       [] 'at'(NewPos) then Next = {NextFrom Sched Moving} in
	  {Browse 'Lift '#Num#' at floor '#NewPos}
	  if NewPos == Next then
	     Sched2 = {RemoveFirst Sched Moving}
	     Next = {NextFrom Sched2 Moving}
	     LeavingDirection 
	  in
	     {Wait {Send Floors.NewPos arrive(Num Moving $)}}
	     LeavingDirection = if Next == nil then
				   NextR = {NextFrom Sched2 {ReverseMoving Moving}}
				in
				   {Browse 'Reversing to:'#NextR}
				   if NextR == nil then
				      notmoving
				   else
				      {Send Cid step(NextR)}
				      {ReverseMoving Moving}
				   end
				else
				   {Send Cid step(Next)}
				   Moving
				end
	     {Send Floors.NewPos leaving(LeavingDirection)}
	     state(NewPos Sched2 LeavingDirection)
	  else
	     {Send Cid step(Next)}
	     state(NewPos Sched Moving)
	  end
       end
    end}
end