extends Node

var LanguageStructure = {
	"V":[["a",8.12],
		["e",12],
		["i",7.31],
		["o",7.68],
		["u",2.88],
		["y",2.11]],
	"C":[["b",1.49],
		["c",2.71],
		["d",4.32],
		["f",2.3],
		["g",2.03],
		["h",5.92],
		["j",0.10],
		["k",0.69],
		["l",3.98],
		["m",2.61],
		["n",6.95],
		["p",1.82],
		["q",0.11],
		["r",6.02],
		["s",6.28],
		["t",9.1],
		["v",1.11],
		["w",2.09],
		["x",0.17],
		["y",2.11],
		["z",0.07]], 
	"P":[["'",1.0]],
	"CharacterPatterns":[
		["VC",0.05], 
		["VCV",1],
		["VCCV",1.1], 
		["VCVC",1.1], 
		["VCVV",1.1], 
		["VCCVC",1.2],
		["VCCVCVC",1.03], 
		["CV",0.04], 
		["CVC",1], 
		["CVCV",1.1], 
		["CVVC",1.1], 
		["CVCC",1.1], 
		["CVVCV",1.1], 
		["CVCCVCV",1.04], 
		["VPCV",0.2],
		#["VPCCV",0.2], 
		#["VPCVC",0.2], 
		["VPCVV",0.2], 
		["VCCPVC",0.25],
		["VCCVPCVC",0.15], 
		["CPVC",0.015], 
		#["CPVCV",0.02], 
		#["CPVVC",0.02], 
		["CPVCC",0.2], 
		["CVVPCV",0.2], 
		["CVCCPVCV",0.15]]
		}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GetVCPattern():
	return LanguageStructure["CharacterPatterns"][NewRand(LanguageStructure["CharacterPatterns"].size())]
	
func NewRand(_max):
	randomize()
	return randi() % _max # int(rand_range(0, _max))
	
func GetWeightedItem(CharacterList, distribution_test):
	if (distribution_test < 1):
		distribution_test = 1
		
	var c1 = []
	for i in distribution_test:
		c1.append(CharacterList[NewRand(CharacterList.size())])
	
	c1.sort_custom(self, "DistributionComparison")
	
	return c1[0]
	pass

func DistributionComparison(a, b):
	return a[1] > b[1]

func CreateWord():
	var word = CreateUnsafeWord()
	var threshold = 5
	while $ProfanityFilter.isRestricted(word):
		#print("profanity filtered: ", word)
		word = CreateWord()
		threshold -= 1
		if threshold < 1: break
	return word

func CreateUnsafeWord():
	var pattern = GetWeightedItem(LanguageStructure["CharacterPatterns"],2)[0]
	var output = ""
	for i in pattern.length():
		if LanguageStructure.has(pattern[i]):
			output += GetWeightedItem(LanguageStructure[pattern[i]],8)[0]
		else:
			output += pattern[i]
	return(output)

func CreateWordList(_qty):
	var words = []
	for i in _qty:
		words.append(CreateWord())
	return words

func RawLetters(qty):
	var FullLetterList = []
	FullLetterList.append_array(LanguageStructure["V"])
	FullLetterList.append_array(LanguageStructure["C"])
	var letters = ""
	for i in qty:
		letters += FullLetterList[randi() % FullLetterList.size()-1][0]
	return letters
