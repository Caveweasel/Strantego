extends Node

var startresourceamount = 30
var maxresourceamount = 100
var cameray = 668

var money = 100 #How much money you have
var maxmoney = 100000 #How much money you can have
var levelcompletedmoney = 1000 #How much money you earn from completing a level
var levelreplayedmoney = 100 #How much money you earn from replaying a level
var startresourceupgradeamount = 10
var maxresourceupgradeamount = 50
var unlockedstartresourceupgrades = [false, false]
var unlockedmaxresourceupgrades = [false, false]
# {"L. niger": true, "F. fusca": false, "L. flavus": false}
var levelsunlocked = [false,true,false,false,false,false,false,false,false,false #EU Tier 1
	]
var levelsbeaten = [false,false,false,false,false,false,false,false,false,false #EU Tier 1
	]

var unlockedspecies = [true, false, false, #L. niger, F. fusca, L. flavus
	]


func unlock_start_resource_upgrade(num):
	if not unlockedstartresourceupgrades[num]:
		startresourceamount += startresourceupgradeamount
		unlockedstartresourceupgrades[num] = true


func unlock_max_resource_upgrade(num):
	if not unlockedmaxresourceupgrades[num]:
		maxresourceamount += maxresourceupgradeamount
		unlockedmaxresourceupgrades[num] = true
