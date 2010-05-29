declare NewPortObject2
fun {NewPortObject2 Proc}
Sen in
    thread for Msj in Sen do {Proc Msj} end end
    {NewPort Sen}
end
