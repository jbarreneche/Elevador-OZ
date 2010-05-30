\insert 'Timer.oz'
\insert 'NewPortObject.oz'

declare AppendableTimer
fun {AppendableTimer Oid}
   Tid = {Timer}
   Pid = {NewPortObject state(0 false)
    fun {$ state(Time Running) Msg}
       case Msg
       of addtime(T) then
	  if Running
	  then state(T + Time Running)
	  else
	     {Send Tid starttimer(T + Time Pid)}
	     state(0 true)
	  end
       [] stoptimer then
	  if Time > 0 then
	     {Send Tid starttimer(Time Pid)}
	     state(0 true)
	  else
	     {Send Oid stoptimer}
	     state(0 false)
	  end
       end
    end}
in
   Pid
end
