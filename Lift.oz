\insert 'NewPortObject.oz'
\insert 'ScheduleSmart.oz'
\insert 'Movement.oz'

declare Lift

fun {Lift Num Init Cid Floors}
   fun {PrependHistory Pos Moving HistoryStack}
       parada(piso:Pos dir:Moving.dir) | HistoryStack
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
	  if N == Pos andthen SchedDir == NotMoving then
	     {Wait {Send Floors.Pos arrive(Num Dir $)}}
	     state(Pos Sched NotMoving HistoryStack)
	  else Sched2 Moving in
	     if SchedDir == NotMoving
             then 
                % En este caso no debería haber nada en schedule salvo lo que llegó
                {Send Cid step(N)}
                Sched2 = {Reschedule Sched Pos {MovingFromTo Pos N} N Dir}
                % NSched = {RemoveFirst Sched2 Dir}
                state(Pos Sched2 Dir HistoryStack)
             else
                Moving = {MovingFromTo Pos {NextFrom Sched SchedDir}}
                Sched2 = {Reschedule Sched Pos Moving N Dir}
                state(Pos Sched2 SchedDir HistoryStack)
             end
	  end
       [] press(N) then
          if N == Pos andthen SchedDir == NotMoving then
	     {Wait {Send Floors.Pos arrive(Num SchedDir $)}}
	     state(Pos Sched NotMoving HistoryStack)
          else Dir = {MovingFromTo Pos N} in
             state(Pos {Reschedule Sched Pos Dir N Dir} SchedDir HistoryStack)
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
                if {NextFrom NSched Moving.reverse} \= nil then
                   NSchedDir = Moving.reverse
                   NPos = {NextFrom NSched NSchedDir}
                elseif {NextFrom NSched Moving} \= nil then
                   NSchedDir = SchedDir
                   NPos = {NextFrom NSched NSchedDir}
                else
                   NSchedDir = NotMoving
                   NPos = nil
                end
             end

             NMoving = {MovingFromTo CPos NPos}
             if NMoving \= NotMoving then {Send Cid step(NPos)} end

	     {Send Floors.CPos leaving(NMoving)}
             UpdatedHistoryStack = {PrependHistory CPos NMoving HistoryStack}
             if NMoving == NotMoving then
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
                NSchedDir = NotMoving
             end

             NMoving = {MovingFromTo CPos NPos}
	     {Send Floors.CPos leaving(NMoving)}

             if NMoving \= NotMoving then {Send Cid step(NPos)} end
	     {Send Floors.CPos leaving(NMoving)}
             UpdatedHistoryStack = {PrependHistory CPos NMoving HistoryStack}
             if NMoving == NotMoving then
                {ShowFullHistory UpdatedHistoryStack}
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
