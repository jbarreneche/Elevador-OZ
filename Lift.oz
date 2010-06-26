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
    fun {$ state(Pos Sched SchedDir History) Msg}
       case Msg
       of call(FNum CallDir) then
	  {Browse 'Lift '#Lid#' needed at floor '#FNum}
	  if FNum == Pos andthen SchedDir == NotMoving then
	     {Wait {Send Floors.Pos arrive(Lid CallDir $)}}
	     state(Pos Sched NotMoving History)
	  else Sched2 Moving in
	     if SchedDir == NotMoving
             then 
                % En este caso no debería haber nada en schedule salvo lo que llegó
                {Send Cid step(FNum)}
                Sched2 = {Reschedule Sched Pos {MovingFromTo Pos FNum} FNum CallDir}
                state(Pos Sched2 CallDir History)
             else
                Moving = {MovingFromTo Pos {NextFrom Sched SchedDir}}
                Sched2 = {Reschedule Sched Pos Moving FNum CallDir}
                state(Pos Sched2 SchedDir History)
             end
	  end
       [] press(FNum) then
          if FNum == Pos andthen SchedDir == NotMoving then
	     {Wait {Send Floors.Pos arrive(Lid SchedDir $)}}
	     state(Pos Sched NotMoving History)
          else Dir = {MovingFromTo Pos FNum} in
             state(Pos {Reschedule Sched Pos Dir FNum Dir} SchedDir History)
          end
       [] 'at'(CPos) then
          MDir = {MovingFromTo Pos CPos}
          SDir = SchedDir
          MFloor = {NextFrom Sched MDir}
          SFloor = {NextFrom Sched SDir}
          RFloor = {NextFrom Sched MDir.reverse}
       in
	  {Browse 'Lift '#Lid#' at floor '#CPos}
          case MFloor
          of !CPos then NSched = {RemoveFirst Sched MDir} in
             {Browse 'Arrived au correct!'#NSched}
             {Send Floors.CPos arrive(Lid MDir)}
             state(CPos NSched MDir#SDir {PrependHistory CPos MDir History})
          [] nil then % Si no tengo ninguno en la posición que me muevo sigo con los planes de Schedule
             case SFloor
             of !CPos then NSched = {RemoveFirst Sched MDir} in
                {Browse 'Arrived au reverse!'}
                {Send Floors.CPos arrive(Lid SDir)}
                state(CPos NSched MDir#SDir {PrependHistory CPos SDir History})
             else % Recordemos que SFloor no puede ser nil, porque si llegué a un piso es que hay un pedido en la dirección de Schedule
                {Send Cid step(SFloor)}
                state(CPos Sched SchedDir History)
             end
          else % Hay alguno en la dirección que me muevo pero no es en el que estoy
             {Send Cid step(MFloor)}
             state(CPos Sched SchedDir History)
          end
       [] dismiss then
          MDir#SDir = SchedDir
          MFloor = {NextFrom Sched MDir}
          SFloor = {NextFrom Sched SDir}
       in
          case MFloor
          of !Pos then
             % La posición actual sigue siendo una del recorrido (a.k.a. presionaron el botón del mismo piso)
             {Send Floors.Pos arrive(Lid MDir)}
             state(Pos {RemoveFirst Sched MDir} SchedDir {PrependHistory Pos MDir History})
          [] nil then
             NSched = {RemoveFirst Sched MDir}
             RFloor = {NextFrom NSched MDir.reverse}
             MFloor = {NextFrom NSched MDir}
          in
             % Me estaba moviendo en una dirección y no quedan mas en dicha dirección
             if RFloor \= nil then % Encuentro un pedido en la dirección reversa
                {Send Cid step(RFloor)}
                state(Pos NSched MDir.reverse History)
             elseif MFloor \= nil then % Encuentro un pedido en la misma dirección pero que se encuentra a contramano
                {Send Cid step(MFloor)}
                state(Pos NSched MDir History)
             else % Ok, no encontré nada mas...
                {ShowFullHistory History}
                state(Pos Sched NotMoving History)
             end
          else
             % Si tengo algo en la dirección que me muevo, continúo con mis planes de movimiento
             {Send Cid step(SFloor)}
             state(Pos Sched SDir History)
          end
             
       end
    end}
end          
