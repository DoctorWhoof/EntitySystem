
#Import "component"
#Import "entitymap"

Using std..
Using component
Using entitymap

Class Entity

	Field enabled			:= True
	Field children			:= New Stack<Entity>
	Field components		:= New Stack<Component>
	
	Global allEntities		:= New EntityMap
	
	Protected
	Field _name				:= "entity"
	Field _parent			:Entity
	Field _firstUpdate		:= True

	Public
	
	'************************************* Instance Properties *************************************	
	
	Property name:String()
		Return _name
	Setter( n:String )
		SetUniqueName( n )
	End
	
	
	Property parent:Entity()
		Return _parent
	Setter( dad:Entity )
		If dad
			Local dadIsMyChild := False
			For local e := Eachin children
				If e = dad
					dadIsMyChild = True
				End
			Next
			
			If dad <> Self And Not dadIsMyChild
				If _parent
					If dad = _parent Then Return
					_parent.children.RemoveEach( Self )			
				End
				_parent = dad
				_parent.children.Push( Self )
			Else
				Print("Entity: " + _name + " can't parent to itself or to one of its own children")
			End
		Else
			If _parent Then _parent.children.RemoveEach( Self )
			_parent = Null
		End
	End
	

	'************************************* Instance Methods *************************************
	

	Method New( name:String )
		SetUniqueName( name )
		allEntities.Add( name, Self )
	End


	Method Attach( comp:Component, index:Int = -1 )
		If index < 0 Then index = components.Length
		components.Insert( index, comp )
		comp.entity = Self
	End


	Method Destroy( removeFromParent:Bool = True )
		OnDestroy()
		allEntities.Remove( _name )

		If parent And removeFromParent
			_parent.children.RemoveEach( Self )
			_parent = Null
		End		
	
		For local e := Eachin children
			'removeFromPArent = false is needed when recursively destroying a hierarchy
			e.Destroy( False )
		Next
		children.Clear()
		
		If Not components.Empty
			For local comp := Eachin components
				comp.OnDestroy()
				comp = Null
			End
			components.Clear()
		End
	End
	
	
	Method Update()
		If _firstUpdate
			_firstUpdate = False
			OnCreate()
			Update()
		Else
			If enabled
				OnUpdate()
				For Local c := Eachin components
					c.Update()
				next
			End
		End
	End
	
	
	Method Reset()
		OnReset()
		For Local c := Eachin components
			c.Reset()
		next	
	End

	
	Method SetUniqueName( name:String )
		allEntities.Remove( Self._name )
		Local n := 0
		Local originalName := name
		While allEntities.Contains( name )
			n += 1
			name = originalName + n
		End
		Self._name = name
		allEntities.Add( name, Self )
	End
	
	
	'************************************* Virtual Methods *************************************
	
	Method OnCreate() Virtual
	End
	
	Method OnUpdate() Virtual
	End
	
	Method OnReset() Virtual
	End

	Method OnDestroy() Virtual
	End

	'************************************* Class Functions *************************************
	

End


