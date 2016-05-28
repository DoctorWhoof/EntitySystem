
'   #Import "entity"
#Import "<std>"

Class EntityMap Extends Map< String, Entity >

	Method Destroy()
		'Similar to Clear(), but Destroys all entities first (which also sends OnDestroy() Events )
		For Local e:= Eachin Values
			e.Destroy()
		End
		Clear()
	End
	
End