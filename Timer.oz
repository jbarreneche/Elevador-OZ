\insert 'NewPortObject2.oz'

declare Timer
fun {Timer}
   {NewPortObject2
    proc {$ Msg}
       case Msg of startimer(T Pid) then
	  thread {Delay T} {Send Pid stoptimer} end
       end
    end}
end
