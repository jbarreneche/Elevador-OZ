\insert 'NewPortObject.oz'
\insert 'Movement.oz'

declare Buttons

fun {Buttons}
   {NewPortObject buttons(up:false down:false)
    fun {$ B=buttons(up:Up down:Down) Msg}
       case Msg
       of clear(!MovingDown) then buttons(up:false down:Down)
       [] clear(!MovingUp) then buttons(up:Up down:false)
       [] clear(!NotMoving) then buttons(up:Up down:Down)
       [] press(!MovingUp) then buttons(up:true down:Down)
       [] press(!MovingDown) then buttons(up:Up down:true)
       end
    end}
end

% {Browse buttons(up:false down:false)}
