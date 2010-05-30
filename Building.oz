\insert 'Floor.oz'
\insert 'LiftShaft.oz'

declare Building

proc {Building FN LN ?Floors ?Lifts}
   Lifts = {MakeTuple lifts LN}
   for I in 1..LN do Cid in
      Lifts.I = {LiftShaft I state(1 nil false) Floors}
   end
   Floors = {MakeTuple floors FN}
   for I in 1..FN do
      Floors.I = {Floor I state(notcalled) Lifts}
   end
end
