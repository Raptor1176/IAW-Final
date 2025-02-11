extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $Container/VBoxContainer2/Username/LineEdit
onready var password : LineEdit = $Container/VBoxContainer2/Password/LineEdit
onready var notification : Label = $Container/Notification

var presionado : int = 0;

func _on_LoginButton_pressed() -> void:
	presionado = 1
	if username.text.empty() or password.text.empty():
		notification.text = "Please, enter your username and password"
		return
	Firebase.login(username.text, password.text, http)
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://interface/Selection/Selection.tscn")

func _on_RegButton_pressed() -> void:
	presionado = 0
	if username.text.empty() or password.text.empty():
		notification.text = "Invalid password or username"
		return
	Firebase.register(username.text, password.text, http)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		if presionado ==1:
			notification.text = "Sign in sucessful!"
		else:
			notification.text = "Registration sucessful!"
