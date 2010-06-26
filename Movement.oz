declare MovingFromTo MovingUp MovingDown

MovingUp = movement(dir:up reverse:MovingDown)
MovingDown = movement(dir:down reverse:MovingUp)
NotMoving = movement(dir:notmoving reverse:NotMoving)
fun {MovingFromTo From To}
   if To == nil then NotMoving
   elseif To > From then MovingUp
   else MovingDown end
end
