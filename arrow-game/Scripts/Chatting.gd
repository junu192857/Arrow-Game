extends Control

enum Skill { Newbie, Middleman, Pro, Demon, Ranker }

@export var icon: TextureRect
@export var chat: Label
@export var username: Label
@export var imojiHolders: Array[Control]

var skill: Skill
var upper_left_arrow: int
var place_of_worship: int
var upper_arrow: int
var down_arrow: int
