\insert 'NewPortObject.oz'

declare Buttons

fun {Buttons}
   {NewPortObject buttons(up:false down:false)
    fun {$ buttons(up:Up down:Down) Msg}
       case Msg
       of clear(up) then buttons(up:false down:Down)
       [] clear(down) then buttons(up:Up down:false)
       [] clear(notmoving) then buttons(up:Up down:Down)
       [] press(up) then buttons(up:true down:Down)
       [] press(down) then buttons(up:Up down:true)
       end
    end}
end

% {Browse buttons(up:false down:false)}