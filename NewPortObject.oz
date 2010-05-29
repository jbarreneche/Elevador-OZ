declare NewPortObject
fun {NewPortObject Inic Fun}
   Sen Ssal in
   thread {FoldL Sen Fun Inic Ssal} end
   {NewPort Sen}
end
