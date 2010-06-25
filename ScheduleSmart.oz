declare EmptySchedule Reschedule RemoveFirst NextFrom

\insert 'SortedSet.oz'
\insert 'Movement.oz'

local
   fun {IsEmpty schedule(up:Up down:Down)} {IsEmptySet Up} andthen {IsEmptySet Down} end
   fun {EmptyPair} schedule(up:{NewAscendingSet} down:{NewDescendingSet}) end
   fun {TailPair Schedule Dir} CDir = Dir.dir RDir = Dir.reverse.dir in
      schedule(CDir:{PopSet Schedule.CDir} RDir:Schedule.RDir)
   end
in
   fun {EmptySchedule}
      smart(current:{EmptyPair} future:{EmptyPair})
   end
   fun {RemoveFirst smart(current:Current future:Future) Dir} CDir = Dir.dir RDir = Dir.reverse.dir in
      if {IsEmptySet Current.CDir} then
         if {IsEmpty Current}
         then smart(current:Future future:{EmptyPair})
         else smart(current:schedule(CDir:Future.CDir RDir:{MergeSet Current.RDir Future.RDir}) future:{EmptyPair})
         end
      else
         smart(current:{TailPair Current Dir} future:Future)
      end
   end
   fun {NextFrom smart(current:Current future:Future) Dir} CDir = Dir.dir in
      {TopSet Current.CDir}
   end
   fun {Reschedule CSched=smart(current:Current future:Future) CFloor CDir NFloor NDir}
      fun {SameDirection CFloor NFloor Direction}
         {MovingFromTo CFloor NFloor} == Direction
      end
      fun {AddToSchedule Sched Floor Dir} CDir = Dir.dir RDir = Dir.reverse.dir in
         schedule(CDir:{AddToSet Sched.CDir Floor} RDir:Sched.RDir)
      end
   in
      if {SameDirection CFloor NFloor CDir}
      then smart(current:{AddToSchedule Current NFloor NDir} future:Future)
      else smart(current:Current future:{AddToSchedule Future NFloor NDir})
      end
   end
end
