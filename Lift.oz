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
   proc {ShowFullHistory History}
      {Browse {List.reverse History $}}
      for I in 1..20 do
         {Send Floors.I showHistory}
      end
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
	  else Sched2 Moving in
	     if SchedDir == notmoving
             then 
                % En este caso no debería haber nada en schedule salvo lo que llegó
                {Send Cid step(N)}
                {Browse Sched}
                Sched2 = {Reschedule Sched Pos {MovingFromTo Pos N} N Dir}
                {Browse Sched2}
                % NSched = {RemoveFirst Sched2 Dir}
                state(Pos Sched2 Dir HistoryStack)
             else
                Moving = {MovingFromTo Pos {NextFrom Sched SchedDir}}
                Sched2 = {Reschedule Sched Pos Moving N Dir}
                state(Pos Sched2 SchedDir HistoryStack)
             end
	  end
       [] 'at'(CPos) then
          Moving = {MovingFromTo Pos CPos}
          NextM = {NextFrom Sched Moving}
          NextS = {NextFrom Sched SchedDir}
          UpdatedHistoryStack
       in
	  {Browse 'Lift '#Num#' at floor '#CPos}
          case CPos
	  of !NextM then
	     USched = {RemoveFirst Sched Moving}
             NSched NPos  NMoving NSchedDir
	  in
             {Browse 'Arrived au correct!'#CPos#' '#NextM}
	     {Wait {Send Floors.CPos arrive(Num SchedDir $)}}
             
             if {NextFrom USched Moving} \= nil then
                NSchedDir = Moving
                NSched = USched
                NPos = {NextFrom NSched NSchedDir}
             else
                NSched = {RemoveFirst USched Moving}
                if {NextFrom NSched {ReverseMoving Moving}} \= nil then
                   NSchedDir = {ReverseMoving Moving}
                   NPos = {NextFrom NSched NSchedDir}
                elseif {NextFrom NSched Moving} \= nil then
                   NSchedDir = SchedDir
                   NPos = {NextFrom NSched NSchedDir}
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
                {ShowFullHistory UpdatedHistoryStack}
             end
	     state(CPos NSched NSchedDir UpdatedHistoryStack)

          %% Si ocurre esto, seguro que Moving \= SchedDir
          [] !NextS then NSched = {RemoveFirst Sched SchedDir} NPos NSchedDir NMoving UpdatedHistoryStack in
             {Browse 'Arrived au contraire'}
	     {Wait {Send Floors.CPos arrive(Num NSchedDir $)}}
             if {NextFrom NSched SchedDir} \= nil then
                NPos = {NextFrom NSched SchedDir}
                NSchedDir = SchedDir
             elseif {NextFrom NSched Moving} \= nil then
                NPos = {NextFrom NSched Moving}
                NSchedDir = Moving
             else
                NPos = nil
                NSchedDir = notmoving
             end

             NMoving = {MovingFromTo CPos NPos}
	     {Send Floors.CPos leaving(NMoving)}

             if NMoving \= notmoving then {Send Cid step(NPos)} end
	     {Send Floors.CPos leaving(NMoving)}
             UpdatedHistoryStack = {PrependHistory CPos NMoving HistoryStack}
             if NMoving == notmoving then
                {Browse {List.reverse UpdatedHistoryStack $}}
             end
	     state(CPos NSched NSchedDir UpdatedHistoryStack)
	  else
             {Browse 'Ok, No one wants me here...'#Sched}
	     {Send Cid step(NextS)}
	     state(CPos Sched SchedDir HistoryStack)
	  end
       end
    end}
end
