
Class Component

	Field enabled			:= True
	Field entity 			:Entity			'The owner of this component
	Field target 			:Entity			'Useful for some components
	
	Global allComponents	:= New List<Component>		'Components do not require unique names, so this is a normal list
	
	Protected
	Field _name 			:= ""
	Field _init				:= False

	Public
	
	'************************************* Instance properties *************************************
	
	Property Name:String() Virtual
		Return _name
	Setter( name:String )
		If name = ""
			name = "ComponentName"
			Print( "Componet: Warning, component created without name. Naming it 'ComponentName'." )
		End
		_name = name
	End	
	
	'************************************* Instance methods *************************************
	
	Method New( name:String )
		Name = name
		allComponents.Add( Self )
	End

	Method Init()
		_init = True
		OnCreate()	
	End
		
	Method Update()
		If Not _init
			Init()
		End
		If enabled
			OnUpdate()
		End
	End
	
	Method Reset()
		If Not _init
			Init()
		End
		OnReset()
	End
	
	Method Destroy()
		allComponents.Remove( Self )
		OnDestroy()
	End

	'************************************* Virtual methods *************************************
	
	Method OnCreate() Virtual
	End
	
	Method OnUpdate() Virtual
	End
	
	Method OnReset() Virtual
	End

	Method OnDestroy() Virtual
	End

End