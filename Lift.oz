\insert 'NewPortObject.oz'
\insert 'ScheduleSmart.oz'
\insert 'Movement.oz'

declare Lift

fun {Lift Lid Init Cid Floors}
   fun {PrependHistory Pos Moving History}
       parada(piso:Pos dir:Moving.dir) | History
   end
   proc {ShowFullHistory History}
      {Browse {List.reverse History $}}
      for I in 1..20 do
         {Send Floors.I showHistory}
      end
   end
in
   {NewPortObject Init
    fun {$ state(Pos Sched Directions History) Msg} MovDir#SchedDir = Directions in
       case Msg
       of call(FNum CallDir) then
	  {Browse 'Lift '#Lid#' needed at floor '#FNum}
	  if FNum == Pos andthen SchedDir == NotMoving then
	     {Wait {Send Floors.Pos arrive(Lid CallDir $)}}
	     state(Pos Sched NotMoving History)
	  else NSched Moving in
	     if SchedDir == NotMoving
             then
                Moving = {MovingFromTo Pos FNum}
                % En este caso no debería haber nada en schedule salvo lo que llegó
                {Send Cid step(FNum)}
                NSched = {Reschedule Sched Pos Moving FNum CallDir}
                state(Pos NSched Moving#CallDir History)
             else
                Moving = {MovingFromTo Pos {NextFrom Sched SchedDir}}
                NSched = {Reschedule Sched Pos Moving FNum CallDir}
                state(Pos NSched Moving#SchedDir History)
             end
	  end
       [] press(FNum) then
          if FNum == Pos andthen SchedDir == NotMoving then
	     {Wait {Send Floors.Pos arrive(Lid SchedDir $)}}
	     state(Pos Sched Directions History)
          else Dir = {MovingFromTo Pos FNum} in
             state(Pos {Reschedule Sched Pos Dir FNum Dir} Directions History)
          end
       [] 'at'(CPos) then
          MFloor = {NextFrom Sched MovDir}
          SFloor = {NextFrom Sched SchedDir}
          RFloor = {NextFrom Sched MovDir.reverse}
       in
	  {Browse 'Lift '#Lid#' at floor '#CPos}
          case MFloor
          of !CPos then NSched = {RemoveFirst Sched MovDir} in
             {Send Floors.CPos arrive(Lid MovDir)}
             state(CPos NSched MovDir#SchedDir {PrependHistory CPos MovDir History})
          [] nil then % Si no tengo ninguno en la posición que me muevo sigo con los planes de Schedule
             case SFloor
             of !CPos then NSched = {RemoveFirst Sched MovDir} in
                {Send Floors.CPos arrive(Lid SchedDir)}
                state(CPos NSched MovDir#SchedDir {PrependHistory CPos SchedDir History})
             else % Recordemos que SFloor no puede ser nil, porque si llegué a un piso es que hay un pedido en la dirección de Schedule
                {Send Cid step(SFloor)}
                state(CPos Sched Directions History)
             end
          else % Hay alguno en la dirección que me muevo pero no es en el que estoy
             {Send Cid step(MFloor)}
             state(CPos Sched Directions History)
          end
       [] dismiss then
          Moving
          MFloor = {NextFrom Sched MovDir}
          SFloor = {NextFrom Sched SchedDir}
       in
          case MFloor
          of !Pos then
             % La posición actual sigue siendo una del recorrido (a.k.a. presionaron el botón del mismo piso)
             {Send Floors.Pos arrive(Lid MovDir)}
             state(Pos {RemoveFirst Sched MovDir} Directions {PrependHistory Pos MovDir History})
          [] nil then
             NSched = {RemoveFirst Sched MovDir}
             RFloor = {NextFrom NSched MovDir.reverse}
             MFloor = {NextFrom NSched MovDir}
          in
             % Me estaba moviendo en una dirección y no quedan mas en dicha dirección
             if RFloor \= nil then % Encuentro un pedido en la dirección reversa
                Moving = {MovingFromTo Pos RFloor}
                {Send Cid step(RFloor)}
                state(Pos NSched Moving#MovDir.reverse History)
             elseif MFloor \= nil then % Encuentro un pedido en la misma dirección pero que se encuentra a contramano
                Moving = {MovingFromTo Pos MFloor}
                {Send Cid step(MFloor)}
                state(Pos NSched Moving#MovDir History)
             else % Ok, no encontré nada mas...
                {ShowFullHistory History}
                state(Pos Sched NotMoving#NotMoving History)
             end
          else
             % Si tengo algo en la dirección que me muevo, continúo con mis planes de movimiento
             {Send Cid step(SFloor)}
             state(Pos Sched Directions History)
          end
             
       end
    end}
end          
