\insert 'AppendableTimer.oz'

declare Door
fun {Door Num Init Fid Lid} Tid = {AppendableTimer Did} Did in
   Did = {NewPortObject Init
	  fun {$ state(Opened Ack) Msg}
	     case Msg
	     of opendoor(A) then
		{Browse 'Opening door '#Num}
		{Send Tid addtime(DoorOpenTime)}
		A = Ack
		state(true Ack)
	     [] stoptimer then NAck in
		{Browse 'Closing doors'}
		Ack = unit
		state(false NAck)
	     end
	  end}
end
