\insert 'NewPortObject2.oz'

declare LiftSystem

fun {LiftSystem Lifts}
   {NewPortObject2 
    proc {$ Msg}
       case Msg
       of call(Num Dir) then Lran in
	  {Browse 'Floor '#Num#' calls a lift!'}
	  Lran = Lifts.(1+{OS.rand} mod {Width Lifts})
	  {Send Lran call(Num Dir)}
       end
    end}
end
