extends Node2D


enum OUTPOST_STATE {LOBBY, FUEL, FUEL_FULL, TURN_IN, TURN_IN_EMPTY}
var main_boiler = "[b]%s[/b]\r\n\r\n%s"
var stats_boiler = "\r\n\r\n[indent][code]%s[/code][/indent]"


func _ready():
	pass # Replace with function body.

func Greeting(Planet):
	var title = "Greetings, Captain %s!" %[ShipData.StarShip.Captain]
	var details = "You have been recruited by the Supercluster Federation to acquire scientific and archaeological data from the remnants of ancient civilizations for study.\r\n\r\n"
	
	details += "The Milky Way Superintelligence has predicted a new filter that our societies must understand to survive. "
	details += "Your colony ship Starscan is uniquely suited to deep space exploration. "
	details += "Please search for ancient civilizations and evidence of their final days. "
	details += "Bring " + str($"/root/GameController/WinLoseCheck".ArtifactsRequiredToWin) + " of these important artifacts to scientists at Federation Outposts around your galaxy for further study. "
	details += "Visit Star Dock at Outpost " + Planet.Name + " to refuel and begin your adventure.\r\n\r\n"
	#details += "\r\n\r\n"
	details += "[indent][code]"
	#details += "[color=#0080ff]Visit Star Dock at Outpost " + Planet.Name + " to refuel.[/color]\r\n"
	#details += "[color=#0080ff]Collect artifacts throughout the sector.[/color]\r\n\r\n"
	details += "[color=#ff0000]You are low on fuel.[/color]\r\n"
	details += "[/code][/indent]\r\n"
	
	
	return main_boiler % [title, details]

func SystemStory(System, Cost):
	var title = "Entering " + System.Name
	var planet_sub_boiler_plate = "%s: %s, %s"
	var txt = "Captain, we are entering system %s. There are %s orbital bodies to explore. " % [System.Name, System.Planets.size()]
	if Cost.Crew > 0:
		txt += "We lack the resources for a safe entry and have reports of casualties throughout the ship. "
	if StarMapData.SystemHasOutpost(System):
		txt += "We can replenish fuel and turn in artifacts at %s Station. " % [StarMapData.GetOutpost(System).Name]
	if StarMapData.SystemHasPlanetWithArtifacts(System):
		txt += "There are faint signs of sentient life emanating from this system. "
	else:
		txt += "This system appears otherwise quiet. "
#	if StarMapData.SystemHasPlanetWithResources(System):
#		txt += "This system has mineral signatures consistent with our resource needs. "
#	if StarMapData.SystemHasPlanetWithHazards(System):
#		txt += "This system is active. Proceed with extreme caution. "
	txt += "\r\n\r\nThe system map is being forwarded to your console. \r\n\r\n"
	var stats = ReportSystemEntryCost(Cost)
	stats += "\r\n" + ScanConfidence(System.Scan)
	
#	for planet in System.Planets:
#		var planetText = planet_sub_boiler_plate % [planet.Name, planet.Type, planet.Size]
#		details = "%s\r\n%s" % [details, planetText]
	
	txt += stats_boiler % [stats]
	return main_boiler % [title, txt]

func ReportSystemEntryCost(cost):
	var report = ""
	
	if cost.Resources > 0:
		report = "[color=#ff0000]You expended %d resources.[/color]\r\n" % [cost.Resources]
	elif cost.Crew > 0:
		report = "[color=#ff0000]You lost %d crew due to lack of resources.[/color]\r\n" % [cost.Crew]	
	elif cost.Crew <= 0:
		return "[color=#00ff00]Interstellar travel is free.[/color]\r\n"
	
	var remainingResources = null
	for cargo in ShipData.StarShip.Inventory:
		if cargo.Type == "Resources":
			remainingResources = cargo
			break
	if remainingResources == null || remainingResources.Quantity == 0:
		report = "%s[color=#ff0000]WARNING: resources depleted![/color]\r\n" % [report]
	
	return report

func ScanConfidence(scan):
	var stat_pos_item_boiler = "[color=#00ff00]%s[/color]\r\n"
	var stat_neg_item_boiler = "[color=#ff0000]WARNING: %s[/color]\r\n"
	var scan_txt = "System scans are currently at %d percent." % [scan * 100]
	var txt = ""
	
	if scan > 0.99:
		txt += stat_pos_item_boiler % [scan_txt]
	elif scan > 0.49:
		txt += stat_neg_item_boiler % [scan_txt]
	else:
		txt += stat_neg_item_boiler % [scan_txt]
	return txt

func RomanNumeral(num):
	var intToroman = { 1: 'I', 4: 'IV', 5: 'V', 9: 'IX', 10: 'X', 40: 'XL', 50: 'L', 90: 'XC', 100: 'C', 400: 'XD', 500: 'D', 900: 'CM', 1000: 'M'}
	var print_order = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
	var roman_num = ''
	
	for x in print_order:
		if num != 0:
			var quotient = num / x
			if quotient != 0:
				for y in range(quotient):
					roman_num += intToroman[x]
			num = num%x
	
	return roman_num

var PlanetHints = {
	"Civilization": { 
		true: ["We have detected faint signs of sentient life. "],
		false: ["We have detected no signs of sentient life. "]
	},
	"Resource": { 
		true: ["This planet appears to be resource rich. "],
		false: ["This planet has no interesting resources. "]
	},
	"Danger": { 
		true: ["This planet has dangerous geological activity. "],
		false: ["This planet is geologically inert. "]
	},
}
func PlanetHint( Planet ):
	var hasCivilzation = (Planet.ArtifactCount > 0)
	var hasResources = (Planet.ResourceCount > 0)
	var hasDanger = (Planet.HazardCount > 0)
	#var Hint = ""
	var rng = RandomNumberGenerator.new()
	rng.seed = Planet.SurfaceSeednumber
	
	var Hint = PlanetHints["Civilization"][hasCivilzation][rng.randi_range(0, PlanetHints["Civilization"][hasCivilzation].size()-1)] + " "
	Hint += PlanetHints["Resource"][hasResources][rng.randi_range(0, PlanetHints["Resource"][hasResources].size()-1)] + " "
	Hint += PlanetHints["Danger"][hasDanger][rng.randi_range(0, PlanetHints["Danger"][hasDanger].size()-1)] + " "
	return Hint

func PlanetStory(System, Planet):
	var title = "%s (%s %s)" % [Planet.Name, System.Name, RomanNumeral(StarMapData.getPlanetID(Planet, System) + 1)]
	var txt = ""
	
	txt += "Captain, %s has entered orbit around %s and we are ready to begin Planetary Operations. \r\n\r\n " % [ ShipData.Ship().Name, Planet.Name]
	txt += PlanetHint(Planet) + "\r\n\r\n"
	txt += "You have the console. "
	
	var scan_txt = "System scans are currently at %s percent." % [System.Scan]
	txt += stats_boiler % [ScanConfidence(System.Scan)]
	return main_boiler % [title, txt]

func Outpost_Promenade(system, planet):
	var txt = "Captain, %s is docked and secure. Word of your mission has reached us and we are honored to host you and your crew. \r\n\r\n " % [ ShipData.Ship().Name]
	txt += "The Station Hub is a cultural nexus of %s, the meeting place of travelers and the people of this system. " % [system.Name]
	txt += "You may refuel and repair your vessel at the Space Port and you may deliver any artifacts in your cargo hold to the Supercluster Federation in the Science Bay. "
	txt += "\r\n\r\n"
	txt += "Welcome to Outpost %s. You are free to roam the facility. " % [ planet.Name]
	txt += "\r\n\r\n"
	return txt

func Outpost_Refuel(system, planet, qty):
	var txt = "%s is currently docked. Maintenance scans and refueling have completed. \r\n\r\n " % [ ShipData.Ship().Name]
	if qty > 0:
		txt += "It looks like you've seen some time in space. All costs are covered by the Supercluster Federation. "
	else:
		txt += "%s is fully fueled and repaired. You are ready to go. " % [ ShipData.Ship().Name]
	txt += "You may re-enter %s System Space when you are ready." % [system.Name]
	
	txt += "\r\n\r\n"
	if qty > 0:
		txt += "[indent][code][color=#00ff00]You have gained %s fuel.[/color][/code][/indent]" % [str(qty)]
	txt += "\r\n\r\n"
	return txt

func Outpost_ScienceBay(system, planet, qty):
	var txt = ""
	if qty > 0:
		txt += "Captain, we have received your latest  %s contributions and will begin researching them immediately. " % [str(qty)]
	else:
		txt += "We couldn't find any artifacts in your cargo hold. Your mission is vital to the survival of humankind. "
	if ShipData.StarShip.DeliveredArtifacts > 0:
		txt += "You have brought us a total of %s artifacts to study. Humanity owes you a debt of gratitude." % [str(ShipData.StarShip.DeliveredArtifacts)]
	
	txt += "\r\n\r\n"
	txt += "Come back when you have gathered more artifacts. We require currently %s to study. You can bring them to us or any Supercluster Outpost." % [ str($"/root/GameController/WinLoseCheck".ArtifactsRequiredToWin - ShipData.StarShip.DeliveredArtifacts)]
		
	txt += "\r\n\r\n"
	if qty > 0:
		txt += "[indent][code][color=#00ff00]You have turned in %s artifacts.[/color][/code][/indent]" % [str(qty)]
	txt += "\r\n\r\n"
	return txt

func OutpostStory(_state, system, planet, qty):
	var title = "Outpost %s" % [planet.Name]
	var txt = ""
	
	match _state:
		OUTPOST_STATE.LOBBY:
			txt += Outpost_Promenade(system, planet)
		OUTPOST_STATE.FUEL:
			txt += Outpost_Refuel(system, planet, qty)
		OUTPOST_STATE.FUEL_FULL:
			txt += Outpost_Refuel(system, planet, qty)
		OUTPOST_STATE.TURN_IN:
			txt += Outpost_ScienceBay(system, planet, qty)
		OUTPOST_STATE.TURN_IN_EMPTY:
			txt += Outpost_ScienceBay(system, planet, qty)
	return main_boiler % [title, txt]


func POIStory(POIType, qty):
	#Told when looting a POI

	var txt = ""
	txt += main_boiler % ["A surface encounter...",_generate_poi_storylet(POIType)]
	txt += stats_boiler % [_poi_item_detail(POIType, qty)]
	
	return txt


func _generate_poi_storylet(POIType):
	var txt = ""
	match POIType:
		"Artifact":
			txt = "Captain, the Away Team has returned successfully from the Resource Extraction Point and deposited an artifact in our cargo hold. "
			txt += "\r\n\r\n"
			txt += "You have uncovered: %s \r\n\r\n" % [$WordGenerator/Artifact.Create(-1, true)]
			#txt += "With it, your science team discovered a message: \r\n\r\n\"%s\" " % [LoremIpsum(1)]
		"Resource":
			txt = "Captain, the Away Team has returned successfully from the Resource Extraction Point and deposited additional resources for system entry in our cargo hold. "
		"Hazard":
			txt = "Captain, a member of the Away Team has perished due to surface and atmospheric instability. "
			var fname = $WordGenerator.CreateWord().capitalize()
			var lname = $WordGenerator.CreateWord().capitalize()
			var fname2 = $WordGenerator.CreateWord().capitalize()
			var fname3 = $WordGenerator.CreateWord().capitalize()
			txt += "Their name was %s %s. They are survived by %s and %s %s. I will begin notifying next of kin. " % [fname, lname, fname2, fname3, lname]
		"Empty":
			txt = "Captain, the Away Team has returned from the Resource Extraction Point empty handed. It appears that this reading was a false positive. "
	
	return txt


func _poi_item_detail(POIType, qty):
	
	var stat_pos_item_boiler = "[color=#00ff00]%s[/color]\r\n"
	var stat_neg_item_boiler = "[color=#ff0000]%s[/color]\r\n"
	
	var txt = ""
	
	match POIType:
		"Artifact":
			txt = stat_pos_item_boiler % ["You have found " + str(qty) + " artifact" + str("s" if qty != 1 else '') + "."]
		"Resource":
			txt = stat_pos_item_boiler % ["You have gained " + str(qty) + " resource."]
		"Hazard":
			txt = stat_neg_item_boiler % ["You have lost " + str(qty) + " crew."]
		"Empty":
			txt = stat_pos_item_boiler % ["There is nothing here."]
	
	return txt



func LowFuel(TowEncounter):
	var outpost = StarMapData.GetOutpost(TowEncounter.nearestOutpostSystem)
	var title = "LOW FUEL DISTRESS RESPONDER"
	var NPCShip = $WordGenerator/NPCShip.GenerateNPCShip(TowEncounter.Friendly)
	var txt = "This is Captain %s of %s Vessel %s, responding to your low fuel distress beacon. \r\n\r\n" %  [NPCShip.Captain, NPCShip.Disposition, NPCShip.FullDesignation]
	
	if TowEncounter.Friendly:
		txt += "The nearest Supercluster Federation outpost is %s Station in the %s system. We have arranged dock space for DSCV %s. You can refuel and resume your journey at Outpost %s." % [outpost.Name, TowEncounter.nearestOutpostSystem.Name, ShipData.Ship().Name, outpost.Name]
		txt += "\r\n\r\n%s Station has standard Star Dock and Scientific facilities." % [outpost.Name]
		txt += "\r\n\r\nInitiating tractor beam on your mark."
	else:
		txt += "You're a long way from safety. We would be happy to help you out of this predicament... For a price. " 
		
		txt += "\r\n\r\nWe will%s take some of your precious crew%s as compensation:\r\n\r\n" % [" either" if TowEncounter.Artifacts > 0 else "", " or cargo" if TowEncounter.Artifacts > 0 else ""]
		txt += "[indent]"
		if TowEncounter.Crew > 0:
			txt += "[color=#ff0000]CONSCRIPT %d CREW[/color]" % [TowEncounter.Crew]
		if TowEncounter.Artifacts > 0:
			txt += "  or  [color=#ff0000]GIVE %d ARTIFACT%s.[/color]" % [TowEncounter.Artifacts, "S" if TowEncounter.Artifacts > 1 else ""]
		txt += "[/indent]"
		txt += "\r\n\r\nIf you are unable or unwilling to comply with our demand%s, you can rot in space, Captain %s. Either way, it's of no matter to us. " % ["s" if TowEncounter.Artifacts > 0 and TowEncounter.Crew > 0 else "", ShipData.Ship().Captain]
		txt += "\r\n\r\nWhat will it be, Captain %s? " % [ShipData.Ship().Captain]
		if TowEncounter.Artifacts > 0:
			txt += "The choice is yours."
	
	return main_boiler % [title, txt]

func Win():
	var title = "Congratulations, Captain %s!" %[ShipData.StarShip.Captain]
	var SectorLeaderName = $WordGenerator.CreateWord().capitalize()
	var txt = "You have delivered the " + str($"/root/GameController/WinLoseCheck".ArtifactsRequiredToWin) + " required artifacts to the Supercluster Federation outposts spread around your sector. "
	txt += "Thanks to you and other captains like you throughout the galaxy, " 
	txt += "we are now able to study these ancient civilizations and find a path of our own through the next Great Filter. "
	txt += "All of humanity owes you a debt of gratitude. " 
	txt += "\r\n\r\n"
	
	txt += "The Supercluster AI has begun corellating all of the new information and the next phase of work is under way "
	txt += "-- all thanks to the hard work of you and your crew." 
	txt += "\r\n\r\n"
		
	txt += "I wonder what we could have learned if we had started down this path sooner. "
	txt += "\r\n\r\n"
	txt += "Sincerely,\r\nSector Leader, %s" % [SectorLeaderName]
	return main_boiler % [title, txt]

func Lose():
	var title = "GAME OVER, Captain %s!" %[ShipData.StarShip.Captain]
	var SectorLeaderName = $WordGenerator.CreateWord().capitalize()
	var txt = "The tragedy that has befallen the crew of %s will ripple through the sector. " % [ ShipData.Ship().Name]
	txt += "The complete and total loss of your crew will not be in vain, though, "
	txt += "as new captains throughout the galaxy step forward to take on the grim task of exploring ancient civilizations. "
	txt += "\r\n\r\n"
	txt += "Your ship and crew will be memorialized in the Hall of Memory of the Supercluster AI as it continues to peer into the future of humanity. "
	txt += "\r\n\r\n"
	txt += "The job is not yet done. Who will step forward next?"
	txt += "\r\n\r\n"
	txt += "May the solar winds be forever at your back,\r\nSector Leader, %s" % [SectorLeaderName]
	return main_boiler % [title, txt]

func PlayStats():
	var stats = ShipData.StarShip.PlayStats
	
	var title = "Your Attributes"
	var SectorLeaderName = $WordGenerator.CreateWord().capitalize()
	var stat_boiler = "[indent][code][color=#00ff00]%s[/color][/code][/indent]\r\n"
	var txt = "During your journey..."
	txt += "\r\n\r\n"
	
	if ShipData.GetPlayStat("SystemsCompleted") > 0 && ShipData.GetPlayStat("SystemsCompleted") / ShipData.GetPlayStat("SystemsVisited") > 0.9:
		txt += stat_boiler % ["You were AN EXPLORER"]
	if ShipData.GetPlayStat("UnknownsLooted") < 3:
		txt += stat_boiler % ["You were CAUTIOUS"]
	if ShipData.GetPlayStat("Tows") < 2:
		txt += stat_boiler % ["You were FUEL EFFICIENT"]
	if ShipData.GetPlayStat("PeopleMet") > 15:
		txt += stat_boiler % ["You were SOCIAL"]
	if ShipData.GetPlayStat("CivilizationsDiscovered") < 2:
		txt += stat_boiler % ["You were A DIPLOMAT"]
	if ShipData.GetPlayStat("ArtifactsTurnedIn") > $"/root/GameController/WinLoseCheck".ArtifactsRequiredToWin:
		txt += stat_boiler % ["You were AN OVERACHIEVER"]
	if ShipData.GetPlayStat("Conscripts") > 10:
		txt += stat_boiler % ["You were RUTHLESS"]
	if ShipData.GetPlayStat("Conscripts") < 1 and ShipData.GetPlayStat("Bribes") > 0:
		txt += stat_boiler % ["You were PROTECTIVE"]
	
	txt += "\r\n\r\n"
	
	if ShipData.GetPlayStat("ArtifactsTurnedIn") > 0:
		txt += stat_boiler % ["You turned in %s artifacts" % [ShipData.GetPlayStat("ArtifactsTurnedIn")]]
	if ShipData.GetPlayStat("SystemsScanned") > 0:
		txt += stat_boiler % ["You scanned %s star systems" % [ShipData.GetPlayStat("SystemsScanned")]]
	if ShipData.GetPlayStat("SystemsVisited") > 0:
		txt += stat_boiler % ["You visited %s systems" % [ShipData.GetPlayStat("SystemsVisited")]]
	if ShipData.GetPlayStat("PlanetsVisited") > 0:
		txt += stat_boiler % ["You visited %s planets" % [ShipData.GetPlayStat("PlanetsVisited")]]
	if ShipData.GetPlayStat("CrewLost") > 0:
		txt += stat_boiler % ["You lost %s souls" % [ShipData.GetPlayStat("CrewLost")]]
	if ShipData.GetPlayStat("CivilizationsDiscovered") > 0:
		txt += stat_boiler % ["You discovered %s civilizations" % [ShipData.GetPlayStat("CivilizationsDiscovered")]]
	if ShipData.GetPlayStat("PeopleMet") > 0:
		txt += stat_boiler % ["You met %s people" % [ShipData.GetPlayStat("PeopleMet")]]
	if ShipData.GetPlayStat("Conscripts") > 0:
		txt += stat_boiler % ["You conscripted %s people" % [ShipData.GetPlayStat("Conscripts")]]
	if ShipData.GetPlayStat("Bribes") > 0:
		txt += stat_boiler % ["You paid pirates %s artifacts" % [ShipData.GetPlayStat("Bribes")]]
	
	
	txt += "\r\n"
	return main_boiler % [title, txt]

func LoremIpsum(_size):
	var txt = ""
	for i in _size:
		txt += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
		txt += "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
		txt += "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
		txt += "aliquip ex ea commodo consequat. "
	return txt
