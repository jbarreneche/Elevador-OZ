declare ScheduleLast

fun {ScheduleLast L N}
   if L \= nil andthen {List.last L} == N then L
   else {Append L [N]} end
end
