
#Import "../coreentity"
Using std..

Function Main()

	'Create entities and initialize them.
	'Initializing is recommended, but not required since it happens automatically (albeit not necessarily when you want it).

	Local arr := New CoreEntity[5,5]
	For Local x := 0 Until 5
		For Local y := 0 Until 5
			arr[ x, y ] = New CoreEntity( "arrayEntity" )
		Next
	Next
	
	Local entity01 := New CoreEntity( "entity01" )
	Local entity02 := New CoreEntity( "entity02" )
	Local entity03 := New CoreEntity( "entity03" )
	Local entity04 := New CoreEntity( "entity04" )
	
	CoreEntity.InitializeAll()
	
	Print( " ~n******************** 2D array with entities test ********************" )
	Print( "Notice how the names are unique, depite the code naming them all the same~n " )

	For Local x := 0 Until 5
		For Local y := 0 Until 5
			Print( arr[ x,y ].Name )
		Next
	Next

	Print( " ~n******************** CoreEntity events and parenting test ********************~n " )
	
	'Form hierarchy
	entity02.Parent = entity01
	entity03.Parent = entity01
	entity04.Parent = entity01

	'This will fail and cause a warning, since it would be a dependency loop
	entity01.Parent = entity03	

	'Add component created on the fly with default name
	entity01.AddComponent( New MessageComponent() )
	
	'Add component with non-default name
	Local cTest := New MessageComponent()
	cTest.Name = "    RenamedComponent"
	entity03.AddComponent( cTest )

	'Get component by name	
	Local c := entity01.GetComponent( "MessageComponent" )
	Print( " ~nComponent: " + c.Name + " attached to " + entity01.Name )
	
	'Perform usual entity events, which are propagated to components as well.
	entity01.Reset()
	entity01.Update()
	entity01.Destroy()
	
End


Class MessageComponent Extends CoreComponent

	Method New()
		Super.New( "MessageComponent" )
	End

	Method OnCreate() Override
		Print( Name + " created" )
	End

	Method OnUpdate() Override
		Print( Name + " is updating..." )
		If entity.children
			For Local e := Eachin entity.children
				Print( e.Name + " is a child of " + entity.Name )
			Next
		End
	End
	
	Method OnReset() Override
		Print( Name + " reset" )
	End
	
	Method OnDestroy() Override
		Print( Name + " destroyed" )
	End

End



