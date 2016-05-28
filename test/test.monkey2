
#Import "../entity"
Using std..

Function Main()

	Print( "2D array with entities test" )

	Local arr := New Entity[5,5]
	For Local x := 0 Until 5
		For Local y := 0 Until 5
			arr[ x, y ] = New Entity( "arrayEntity" )
		Next
	Next

	For Local x := 0 Until 5
		For Local y := 0 Until 5
			Print( arr[ x,y ].name )
		Next
	Next

	Print( "Entity events and parenting test" )

	Local test := New Entity( "test" )
	Local test1 := New Entity( "test1" )
	Local test2 := New Entity( "test2" )
	Local test3 := New Entity( "test3" )
	
	test3.parent = test
	test2.parent = test
	test1.parent = test
	test.parent = test2	'This will fail and cause a warning, since it would be a dependency loop
	
	test.Attach( New PrintMessage )
	test.Reset()
	test.Update()
	test.Destroy()
End


Class PrintMessage Extends Component

	Method OnCreate() Override
		name = "component 'PrintMessage'"
		Print( name + " created" )
	End

	Method OnUpdate() Override
		Print( name + " updated" )
		If entity.children
			Print( name + "'s entity's children: " )
			For Local e := Eachin entity.children
				Print( e.name )
			Next
		End
	End
	
	Method OnReset() Override
		Print( name + " reset" )
	End
	
	Method OnDestroy() Override
		Print( name + " destroyed" )
	End

End



