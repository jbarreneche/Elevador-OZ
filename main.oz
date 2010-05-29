\insert 'Controller.oz'
\insert 'Lift.oz'
\insert 'Floor.oz'

declare F L Building

proc {Building FN LN ?Floors ?Lifts}
   Lifts = {MakeTuple lifts LN}
   for I in 1..LN do Cid in
      Cid = {Controller state(stopped 1 Lifts.I)}
      Lifts.I = {Lift I state(1 nil false) Cid Floors}
   end
   Floors = {MakeTuple floors FN}
   for I in 1..FN do
      Floors.I = {Floor I state(notcalled) Lifts}
   end
end

{Browse 'Starting!!!'}

{Building 20 2 F L}
{Send F.20 call}
{Send F.4 call}
{Send F.10 call}
{Send L.1 call(4)}

{Browse 'Finishing messages sending!'}