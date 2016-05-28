
Class Component

	Field name 				:= "component"
	Field enabled			:= True
	Field entity 			:Entity			'The owner of this component
	Field target 			:Entity			'Useful for some components
	
	Protected
	Field _firstUpdate		:= True

	Public
	'************************************* Instance methods *************************************
	
	Method Update:Void()
		If _firstUpdate
			_firstUpdate = False
			OnCreate()
			Update()
		Else
			If enabled
				OnUpdate()
			End
		End
	End
	
	Method Reset:Void()
		OnReset()
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