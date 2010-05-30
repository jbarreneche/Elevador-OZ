\insert 'Door.oz'
\insert 'Floor.oz'
\insert 'LiftShaft.oz'
\insert 'LiftSystem.oz'

declare Building

proc {Building FN LN ?Floors ?Lifts} LSys = {LiftSystem Lifts} in
   Lifts = {MakeTuple lifts LN}
   for I in 1..LN do Cid in
      Lifts.I = {LiftShaft I state(10 {EmptySchedule} notmoving) Floors}
   end
   Floors = {MakeTuple floors FN}
   for I in 1..FN do Doors = {MakeTuple doors LN} in
      for J in 1..LN do Ack in
	 Doors.J = {Door J state(false Ack) Floors.I Lifts.J}
      end  
      Floors.I = {Floor I LSys Doors}
   end
end
