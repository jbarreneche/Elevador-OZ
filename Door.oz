\insert 'AppendableTimer.oz'

declare Door
fun {Door Num Init Fid Lid} Tid = {AppendableTimer Did} Did in
   Did = {NewPortObject Init
	  fun {$ state(Opened) Msg}
	     case Msg
	     of opendoor then
		{Browse 'Opening door '#Num}
		{Send Tid addtime(DoorOpenTime)}
		state(true)
	     [] stoptimer then
		{Browse 'Closing doors'}
                {Send Lid dismiss}
		state(false)
	     end
	  end}
end
