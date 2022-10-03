extends Node

var SKILL_HIGHER_DAMAGE_MELEE = 0
var SKILL_HIGHER_CRIT_CHANCE_MELEE = 1
var SKILL_HIGHER_ACCURACY = 2
var SKILL_HIGHER_DAMAGE_RANGED_COMBAT = 3
var SKILL_HIGHER_CRIT_CHANCE_RANGED_COMBAT = 4
var SKILL_LIFESTEAL = 5

var music_volume := 0.8
var effect_volume := 0.6

var flags := {
	"Time": 0,
	"Visibility": 0,
	"AlexExhausted": false,
	"DavidPresent": true,
	"PorkusPresent": true,
	"FemaleNinjaPresent": false,
	"MaleNinjaPresent": false,
	"DraculaPresent": false,
	"GandalfPresent": false
}
