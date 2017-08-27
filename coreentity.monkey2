
Namespace coreentity

#Import "corecomponent"
#Import "<std>"

Using std..
Using component

Class CoreEntity

	Field enabled			:= True
	Field children			:= New Stack<CoreEntity>
	Field components		:= New Stack<CoreComponent>		'Main component list, they can be reordered

	Global allEntities		:= New EntityMap
	Global rootEntities		:= New EntityMap

	Protected	
	Field _componentsByName	:= New StringMap<CoreComponent>		'allows fast access indexed by name
	Field _name				:= "entity"
	Field _parent			:CoreEntity							'Parent entity directly above this one
	Field _root				:CoreEntity							'Top parent entity (root of the entire hierarchy)
	Field _init				:= False							'Has this entity been initialized?
	

	'************************************* Public Properties *************************************

	Public

	Property Name:String()
		Return _name
	Setter( n:String )
		SetUniqueName( n )
	End


	Property Parent:CoreEntity() Virtual
		Return _parent
	Setter( dad:CoreEntity ) Virtual
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
				Else
					rootEntities.Remove( _name )
				End
				_parent = dad
				_parent.children.Push( Self )
				OnParent( dad )
				_root = SearchRoot()
			Else
				Print("CoreEntity: Warning, " + _name + " can't parent to itself or to one of its own children.")
			End
		Else
			If Not rootEntities.Contains( Self.Name )
				If _parent Then _parent.children.RemoveEach( Self )
				OnParent( Null )
				_parent = Null
				rootEntities.Add( _name, Self )
			End
			_root = Self
		End
	End
	
	
	Property Root:CoreEntity()
		Return _root
	End
	

	'************************************* Public Methods *************************************


	Method New( name:String )
		SetUniqueName( name )
		allEntities.Add( name, Self )
		rootEntities.Add( name, Self )
		_root = Self
	End


	Method AddComponent:CoreComponent( comp:CoreComponent, index:Int = -1 )
		If _componentsByName.Get( comp.Name )
			Print( "CoreEntity: Warning, a component named " + comp.Name + " already belongs to entity " + Name + "." )
			Return Null
		End
		If index < 0 Then index = components.Length
		_componentsByName.Add( comp.Name, comp )
		components.Insert( index, comp )
		comp.entity = Self
		Return comp
	End


	Method GetComponent:CoreComponent( compName:String )
		Local c := _componentsByName.Get( compName )
		If c Then Return c
		Print( "CoreEntity: Warning, no component named " + compName + " found." )
		Return Null
	End


	Method Destroy( removeFromParent:Bool = True )
		OnDestroy()
		allEntities.Remove( _name )

		If Parent And removeFromParent
			_parent.children.RemoveEach( Self )
			_parent = Null
		End		
	
		For local e := Eachin children
			e.Destroy( False )	'removeFromParent = false is needed when recursively destroying a hierarchy
		Next
		children.Clear()
		
		If Not components.Empty
			For local comp := Eachin components
				comp.Destroy()
				comp = Null
			End
			components.Clear()
		End
	End

	
	Method SetUniqueName( name:String )
		Local isRoot := False
		If rootEntities.Contains( _name )
			isRoot = True
			rootEntities.Remove( Self._name )
		End
		allEntities.Remove( Self._name )
		
		Local n := 0
		Local originalName := name
		While allEntities.Contains( name )
			n += 1
			name = originalName + n
		End
		Self._name = name
		
		allEntities.Add( name, Self )
		If isRoot Then rootEntities.Add( name, Self )		
	End
	
	
	Method SendEvent( event:Void() )
		event()
		For local comp := Eachin components
			comp.SendEvent( event )
		End	
	End
	
	'************************************* Virtual Methods *************************************
	
	Method Init() Virtual
		_init = True
		OnStart()	
	End
	
	Method Update() Virtual
		If Not _init Then Init()
		If enabled
			OnUpdate()
			For Local c := Eachin components
				c.Update()
			next
		End
		For local e := Eachin children
			e.Update()
		Next
	End
	
	Method Reset() Virtual
		If Not _init Then Init()
		OnReset()
		For Local c := Eachin components
			c.Reset()
		next	
	End
	
	Method OnStart() Virtual
	End
	
	Method OnUpdate() Virtual
	End
	
	Method OnReset() Virtual
	End

	Method OnDestroy() Virtual
	End
	
	Method OnParent( e:CoreEntity ) Virtual
	End

	'************************************* Class Functions *************************************
	
	Function InitializeAll()
		'Initializes all entities and components created this far
		'If new entities or components are created after this, make sure to call the Init() method individually
		'Or just call this again (anything already initialized won't initialize again)
		'Another option is to do nothing - everything initializes on the first update if necessary.
		For Local e := Eachin allEntities.Values
			e.Init()
		Next
		For Local c := Eachin CoreComponent.allComponents
			c.Init()
		Next	
	End
	
	'************************************* Private methods *************************************
	
	Protected
	
	'Recursive method to find topmost entity (root)
	Method SearchRoot:CoreEntity()
		Local temp :CoreEntity
		If _parent
			temp = _parent.SearchRoot()
			Return temp
		End
		Return Self
	End


End

Class EntityMap Extends Map< String, CoreEntity >

	Method Destroy()
		'Similar to Clear(), but Destroys all entities first (which also sends OnDestroy() Events )
		For Local e:= Eachin Values
			e.Destroy()
		End
		Clear()
	End
	
	Method List()
		Print( "CoreEntity: Listing all entities..." )
		For Local e:= Eachin Values
			Print( e.Name )
		End
	End
	
End


