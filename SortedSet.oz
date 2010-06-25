declare NewAscendingSet NewDescendingSet AddToSet IsEmptySet PopSet TopSet MergeSet 

local
   fun {NewSet Dir}
      Dir#nil
   end
   fun{Add Pred List Value}
      case List
      of nil then [Value]
      [] H|T andthen H == Value then List
      [] H|T andthen {Pred H Value} then H|{Add Pred T Value}
      else Value|List
      end
   end
   fun {AscendingAdd List Value} {Add fun{$ A B} A < B end List Value} end
   fun {DescendingAdd List Value} {Add fun{$ A B} A > B end List Value} end
   fun {AddList OSet List}
      case List
      of nil then OSet
      [] H|T then {AddList {AddToSet OSet H} T}
      end
   end
in
   fun {NewAscendingSet}
      {NewSet asc}
   end
   fun {NewDescendingSet}
      {NewSet dsc}
   end
   fun {AddToSet OSet Value}
      case OSet
      of asc#Set then asc#{AscendingAdd Set Value}
      [] dsc#Set then dsc#{DescendingAdd Set Value}
      else OSet
      end
   end
   fun {IsEmptySet OSet}
      case OSet
      of _#nil then true
      else false end
   end
   fun {TopSet OSet}
      case OSet
      of _#nil then nil
      [] _#L then L.1
      else nil end
   end
   fun {PopSet OSet} Type#List = OSet in
      Type#List.2
   end
   fun {MergeSet OSet NSet} _#List = NSet in
      {AddList OSet List}
   end
end
