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
      if Destination == nil then notmoving
      elseif Origin < Destination then up
      else down end
   end
   fun {PrependHistory Pos Moving HistoryStack}
       parada(piso:Pos dir:Moving) | HistoryStack
   end
in
   {NewPortObject Init
    fun {$ state(Pos Sched SchedDir HistoryStack) Msg}
       case Msg
       of call(N Dir) then
	  {Browse 'Lift '#Num#' needed at floor '#N}
	  if (N == Pos) andthen (SchedDir == notmoving) then
	     {Wait {Send Floors.Pos arrive(Num Dir $)}}
	     state(Pos Sched notmoving HistoryStack)
	  else Sched2 = {Reschedule Sched Pos SchedDir N Dir} NSched in
	     if SchedDir == notmoving
             then 
                % En este caso no debería haber nada en schedule salvo lo que llegó
                {Send Cid step(N)}
                {Browse 'Pepe...'}
                {Browse Sched2}
                NSched = {RemoveFirst Sched2 Dir}
                {Browse NSched}
                state(Pos NSched Dir HistoryStack)
             else
                state(Pos Sched2 SchedDir HistoryStack)
             end
	  end
       [] 'at'(CPos) then
          Moving = {MovingFromTo Pos CPos}
          Next = {NextFrom Sched SchedDir}
          UpdatedHistoryStack
       in
	  {Browse 'Lift '#Num#' at floor '#CPos}
	  if CPos == Next then
	     USched = {RemoveFirst Sched SchedDir}
             NSched NPos  NMoving NSchedDir
	  in
	     {Wait {Send Floors.CPos arrive(Num SchedDir $)}}
             
             {Browse 'Salame'}
             {Browse Sched}
             {Browse NSched}
             if {NextFrom USched SchedDir} \= nil then
                NSchedDir = SchedDir
                NSched = USched
                NPos = {NextFrom NSched SchedDir}
             else
                NSched = {RemoveFirst USched SchedDir}
                if {NextFrom NSched {ReverseMoving SchedDir}} \= nil then
                   NSchedDir = {ReverseMoving SchedDir}
                   NPos = {NextFrom NSched {ReverseMoving SchedDir}}
                elseif {NextFrom NSched SchedDir} \= nil then
                   {Browse 'Buena'}
                   NSchedDir = SchedDir
                   NPos = {NextFrom NSched SchedDir}
                   {Browse NPos}
                else
                   NSchedDir = notmoving
                   NPos = nil
                end
             end
             NMoving = {MovingFromTo CPos NPos}

             if NMoving \= notmoving then {Send Cid step(NPos)} end

	     {Send Floors.CPos leaving(NMoving)}
             UpdatedHistoryStack = {PrependHistory CPos NMoving HistoryStack}
             if NMoving == notmoving then
                {Browse {List.reverse UpdatedHistoryStack $}}
                {Browse NSched}
             end
	     state(CPos NSched NSchedDir UpdatedHistoryStack)
	  else
             {Browse 'Jorge'}
             {Browse Next}
             {Browse SchedDir}
	     {Send Cid step(Next)}
	     state(CPos Sched SchedDir HistoryStack)
	  end
       end
    end}
end
