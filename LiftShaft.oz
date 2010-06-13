\insert 'Controller.oz'
\insert 'Lift.oz'

declare LiftShaft
fun {LiftShaft I state(F S M) Floors}
   Cid = {Controller state(stopped F Lid)}
   Lid = {Lift I state(F S M nil) Cid Floors}
in Lid end
