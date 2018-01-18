package classes.Items.Consumables 
{
	import classes.BodyParts.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.Items.Consumable;
	import classes.Items.ConsumableLib;
	import classes.PerkLib;
	import classes.lists.ColorLists;
	
	/**
	 * Ferret transformative item.
	 */
	public class FerretFruit extends Consumable 
	{
		public function FerretFruit() 
		{
			super("Frrtfrt","FerretFrt","a ferret fruit", ConsumableLib.DEFAULT_VALUE, "This fruit is curved oddly, just like the tree it came from.  The skin is fuzzy and brown, like the skin of a peach.");
		}
		
		override public function useItem():Boolean
		{
			var tfSource:String = "ferretTF";
			changes = 0;
			changeLimit = 1;
			var temp:int = 0;
			var x:int = 0;
			
			clearOutput();
			credits.authorText = "Revised by Coalsack";
			outputText("Feeling parched, you gobble down the fruit without much hesitation. Despite the skin being fuzzy like a peach, the inside is relatively hard, and its taste reminds you of that of an apple.  It even has a core like an apple. Finished, you toss the core aside.");

			//BAD END:
			if (
				player.face.type === Face.FERRET &&
				player.ears.type === Ears.FERRET &&
				player.tail.type === Tail.FERRET &&
				player.lowerBody.type === LowerBody.FERRET &&
				player.hasFur() &&
				!player.hasPerk(PerkLib.TransformationResistance)
			) {
				//Get warned!
				if (flags[kFLAGS.FERRET_BAD_END_WARNING] === 0) {
					outputText("\n\nYou find yourself staring off into the distance, dreaming idly of chasing rabbits through a warren.  You shake your head, returning to reality.  <b>Perhaps you should cut back on all the Ferret Fruit?</b>");
					player.inte -= 5 + rand(3);
					if (player.inte < 5) player.inte = 5;
					flags[kFLAGS.FERRET_BAD_END_WARNING] = 1;
				}
				//BEEN WARNED! BAD END! DUN DUN DUN
				else if (rand(3) === 0)
				{
					//-If you fail to heed the warning, it’s game over:
					outputText("\n\nAs you down the fruit, you begin to feel all warm and fuzzy inside.  You flop over on your back, eagerly removing your clothes.  You laugh giddily, wanting nothing more than to roll about happily in the grass.  Finally finished, you attempt to get up, but something feels...  different.  Try as you may, you find yourself completely unable to stand upright for a long period of time.  You only manage to move about comfortably on all fours.  Your body now resembles that of a regular ferret.  That can’t be good!  As you attempt to comprehend your situation, you find yourself less and less able to focus on the problem.  Your attention eventually drifts to a rabbit in the distance.  You lick your lips. Nevermind that, you have warrens to raid!");
					getGame().gameOver();
					return false;
				}
			}
			//Reset the warning if ferret score drops.
			else
			{
				flags[kFLAGS.FERRET_BAD_END_WARNING] = 0;
			}
			
			if (rand(2) === 0) changeLimit++;
			if (rand(2) === 0) changeLimit++;
			if (rand(3) === 0) changeLimit++;
			if (player.findPerk(PerkLib.HistoryAlchemist) >= 0) changeLimit++;
			if (player.findPerk(PerkLib.TransformationResistance) >= 0) changeLimit--;
			//Ferret Fruit Effects
			//- + Thin:
			if (player.thickness > 15 && changes < changeLimit && rand(3) === 0)
			{
				outputText("\n\nEach movement feels a tiny bit easier than the last.  Did you just lose a little weight!? (+2 thin)");
				player.thickness -=2;
				changes++;
			}
			//- If speed is > 80, increase speed:
			if (player.spe100 < 80 && rand(3) === 0 && changes < changeLimit) {
				outputText("\n\nYour muscles begin to twitch rapidly, but the feeling is not entirely unpleasant.  In fact, you feel like running.");
				dynStats("spe",1);
				//[removed:1.4.10]//changes++;
			}
			//- If male with a hip rating >4 or a female/herm with a hip rating >6:
			if (((!player.hasCock() && player.hips.rating > 6) || (player.hasCock() && player.hips.rating > 4)) && rand(3) === 0 && changes< changeLimit)
			{
				outputText("\n\nA warm, tingling sensation arises in your [hips].  Immediately, you reach down to them, concerned.  You can feel a small portion of your [hips] dwindling away under your hands.");
				player.hips.rating--;
				if (player.hips.rating > 10) player.hips.rating--;
				if (player.hips.rating > 15) player.hips.rating--;
				if (player.hips.rating > 20) player.hips.rating--;
				if (player.hips.rating > 23) player.hips.rating--;
				changes++;
			}
			//- If butt rating is greater than “petite”:
			if (player.butt.rating >= 8 && rand(3) === 0 && changes < changeLimit)
			{
				outputText("\n\nYou cringe as your [butt] begins to feel uncomfortably tight.  Once the sensation passes, you look over your shoulder, inspecting yourself.  It would appear that your ass has become smaller!");
				player.butt.rating--;
				if (player.butt.rating > 10) player.butt.rating--;
				if (player.butt.rating > 15) player.butt.rating--;
				if (player.butt.rating > 20) player.butt.rating--;
				if (player.butt.rating > 23) player.butt.rating--;
				changes++;
			}

			//-If male with breasts or female/herm with breasts > B cup:
			if (!flags[kFLAGS.HYPER_HAPPY] && (player.biggestTitSize() > 2 || (player.hasCock() && player.biggestTitSize() >= 1)) && rand(2) === 0 && changes < changeLimit)
			{
				outputText("\n\nYou cup your tits as they begin to tingle strangely.  You can actually feel them getting smaller in your hands!");
				for(x = 0; x < player.bRows(); x++)
				{
					if (player.breastRows[x].breastRating > 2 || (player.hasCock() && player.breastRows[x].breastRating >= 1))
					{
						player.breastRows[x].breastRating--;
					}
				}
				changes++;
				//(this will occur incrementally until they become flat, manly breasts for males, or until they are A or B cups for females/herms)
			}
			//-If penis size is > 6 inches:
			if (player.hasCock())
			{
				//Find longest cock
				temp = -1;
				for(x = 0; x < player.cockTotal(); x++)
				{
					if (temp === -1 || player.cocks[x].cockLength > player.cocks[temp].cockLength) temp = x;
				}
				if (temp >= 0 && rand(2) === 0 && changes < changeLimit)
				{
					if (player.cocks[temp].cockLength > 6 && !flags[kFLAGS.HYPER_HAPPY])
					{
						outputText("\n\nA pinching sensation racks the entire length of your " + player.cockDescript(temp) + ".  Within moments, the sensation is gone, but it appears to have become smaller.");
						player.cocks[temp].cockLength--;
						if (rand(2) === 0) player.cocks[temp].cockLength--;
						if (player.cocks[temp].cockLength >= 9) player.cocks[temp].cockLength -= rand(3) + 1;
						if (player.cocks[temp].cockLength/6 >= player.cocks[temp].cockThickness)
						{
							outputText("  Luckily, it doesn’t seem to have lost its previous thickness.");
						}
						else
						{
							player.cocks[temp].cockThickness = player.cocks[temp].cockLength/6;
						}
						changes++;
					}
				}
			}
			//-If the PC has quad nipples:
			if (player.averageNipplesPerBreast() > 1 && rand(4) === 0 && changes < changeLimit)
			{
				outputText("\n\nA tightness arises in your nipples as three out of four on each breast recede completely, the leftover nipples migrating to the middle of your breasts.  <b>You are left with only one nipple on each breast.</b>");
				for(x = 0; x < player.bRows(); x++)
				{
					player.breastRows[x].nipplesPerBreast = 1;
				}
				changes++;
			}
			//If the PC has gills:
			if (player.hasGills() && rand(4) === 0 && changes < changeLimit) {
				mutations.updateGills();
			}
			//Hair
			var oldHairType:Number = player.hair.type;
			var hasFerretHairColor:Boolean = ColorLists.FERRET_HAIR.indexOf(player.hair.color) !== -1;
			if ((player.hair.type !== Hair.NORMAL || !hasFerretHairColor || player.hair.length <= 0) && rand(4) === 0 && changes < changeLimit)
			{
				if (!hasFerretHairColor)
					player.hair.color = randomChoice(ColorLists.FERRET_HAIR);

				flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] = 0;
				player.hair.type = Hair.NORMAL;

				if (player.hair.length <= 0) {
					player.hair.length = 1;
					outputText("\n\nThe familiar sensation of hair returns to your head. After looking yourself on the stream,"
					          +" you confirm that your once bald head now has normal, short [hairColor] hair.");
				} else if (oldHairType === Hair.NORMAL && !hasFerretHairColor) {
					outputText("\n\nA mild tingling on your scalp makes your check yourself on the stream. Seems like the fruit is changing your"
					          +" hair this time, turning it into [hair].");
				} else {
					switch (oldHairType) {
						case Hair.FEATHER:
							outputText("\n\nWith the taste of the fruit still lingering, you start feeling an odd itch on your scalp."
							          +" When you scratch it, you see how your feathered hair has begin to shed, downy feathers falling from your"
							          +" head until you’re left bald. It doesn’t last long, fortunately, as you feel hairs sprouting from your scalp."
							          +" Checking the changes on the nearby river, you get a glimpse of how your new [hairColor] hair begins to"
							          +" rapidly grow. <b>You now have [hair]!</b>");
							break;

						case Hair.GOO:
							player.hair.length = 1;
							outputText("\n\nAfter having gulped down the fruit last bit, a lock of gooey hair falls over your forehead. When you try"
							          +" to examine it, the bunch of goo falls to the ground and evaporates. As you tilt your head to see what"
							          +" happened, more and more patches of goo start falling from your head, disappearing on the ground with the"
							          +" same speed. Soon, your scalp is devoid of any kind of goo, albeit entirely bald.");
							outputText("\n\nNot for long, it seems, as the familiar sensation of hair returns to your head a moment later."
							          +" After looking yourself on the stream, you confirm that"
							          +" your once bald head now has normal, short [hairColor] hair.");
							break;

						/* [INTERMOD: xianxia]
						case Hair.GORGON:
							player.hair.length = 1;
							outputText("\n\nAs the fruit last juices run through your mouth, the scaled critters on your head shake wildly in pained"
							          +" displeasure. Then, a sudden heat envelopes your scalp. The transformative effects of the sweet fruit meal"
							          +" make themselves notorious, as the writhing mess of snakes start hissing uncontrollably."
							          +" Many of them go rigid, any kind of life that they could had taken away by the root effects."
							          +" Soon, all of the snakes that made your hair are limp and lifeless.");
							outputText("\n\nTheir dead bodies are separated from you head by a scorching sensation, and start falling to the ground,"
							          +" turning to dust in a matter of seconds. Examining your head on the stream, you realize that you have"
							          +" a normal, healthy scalp, though devoid of any kind of hair.");
							outputText("\n\nThe effects don’t end here, though as the familiar sensation of hair returns to your head a moment later."
							          +" After looking yourself on the stream again, you confirm that"
							          +" <b>your once bald head now has normal, short [hairColor] hair</b>.");
							break;
						*/

						default:
							outputText("\n\nA mild tingling on your scalp makes your check yourself on the stream. Seems like the fruit is changing"
							          +" your hair this time, turning it into [hair].");
					}
				}
				changes++;
			}
			//If the PC has four eyes:
			if ((player.eyes.type === Eyes.FOUR_SPIDER_EYES || player.eyes.count > 2) && rand(3) === 0 && changes < changeLimit)
			{
				outputText("\n\nYou vision turns black, forcing you to freeze where you are as the sudden blindness put you in danger of hitting"
				          +" something dangerous. Thank Marae, it doesn’t take long to your sight to return as usual, only with a little change."
				          +" As your vision filed feels oddly changed, you check the changes in your visage, noting that the number of eyes in your"
				          +" head has dropped to the average pair! <b>You have normal human eyes again!</b>");
				player.eyes.type = Eyes.HUMAN;
				player.eyes.count = 2;
				changes++;
			}
			//Go into heat
			if (rand(3) === 0 && changes < changeLimit) {
				if (player.goIntoHeat(true)) {
						changes++;
				}
			}
			//Neck restore
			if (player.neck.type != Neck.NORMAL && changes < changeLimit && rand(4) == 0) mutations.restoreNeck(tfSource);
			//Rear body restore
			if (player.hasNonSharkRearBody() && changes < changeLimit && rand(5) == 0) mutations.restoreRearBody(tfSource);
			//Ovi perk loss
			if (rand(5) === 0) {
				mutations.updateOvipositionPerk(tfSource);
			}
			//Turn ferret mask to full furface.
			if (player.face.type === Face.FERRET_MASK && player.hasFur() && player.ears.type === Ears.FERRET && player.tail.type === Tail.FERRET && player.lowerBody.type === LowerBody.FERRET && rand(4) === 0 && changes < changeLimit)
			{
				outputText("\n\nNumbness overcomes your lower face, while the rest of your head is caught by a tingling sensation."
				          +" Every muscle on your face tenses and shifts, while the bones and tissue rearrange, radically changing the shape"
				          +" of your head. You have troubles breathing as the changes reach your nose, but you manage to see as it changes into an"
				          +" animalistic muzzle. At its top, your nose acquire a triangular shape, proper of a ferret and an adorable pink color."
				          +" You jaw joins it and your teeth sharpen, reshaping in the way of belonging on a little carnivore,"
				          +" albeit without looking menacing or intimidating.");
				outputText("\n\nOnce you’re face and jaw has reshaped, fur covers the whole of your head. The soft sensation is quite pleasant."
				          +" It has a [furColor] coloration, turning into white at your muzzle, cheeks and ears. The darkened skin around your eyes"
				          +" also changes, turning into a mask of equally soft fur colored in a darker shade of [furColor]."
				          +" Well, seems like <b>you now have an animalistic, ferret face!</b>");
				player.face.type = Face.FERRET;
				changes++;
			}
			//If face is human:
			if (player.face.type === Face.HUMAN && rand(3) === 0 && changes < changeLimit)
			{
				outputText("\n\nA sudden itching begins to encompass the area around your eyes. Grunting in annoyance, you rub furiously at the"
				          +" afflicted area. Once the feeling passes, you make your way to the nearest reflective surface to see if anything"
				          +" has changed. There, your suspicions are confirmed. The [skinFurScales] around your eyes has darkened."
				          +" <b>You now have a ferret mask!</b>");
				player.face.type = Face.FERRET_MASK;
				changes++;
			}
			//If face is not ferret, has ferret ears, tail, and legs:
			if ([Face.HUMAN, Face.FERRET_MASK, Face.FERRET].indexOf(player.face.type) === -1 && rand(3) === 0 && changes < changeLimit)
			{
				outputText("\n\nYou groan uncomfortably as the bones in your [face] begin to rearrange.  You grab your head with both hands,"
				          +" rubbing at your temples in an attempt to ease the pain.  As the shifting stops, you frantically feel at your face."
				          +" The familiar feeling is unmistakable. <b>Your face is human again!</b>");
				player.face.type = Face.HUMAN;
				changes++;
			}
			//No fur, has ferret ears, tail, and legs:
			if (!player.hasFur() && player.ears.type === Ears.FERRET && player.tail.type === Tail.FERRET && player.lowerBody.type === LowerBody.FERRET && rand(4) === 0 && changes < changeLimit)
			{
				outputText("\n\nYour skin starts to itch like crazy as a thick coat of fur sprouts out of your skin.");
				//If hair was not sandy brown, silver, white, or brown
				if (player.hair.color !== "sandy brown" && player.hair.color !== "silver" && player.hair.color !== "white" && player.hair.color !== "brown")
				{
					outputText("\n\nOdder still, all of your hair changes to ");
					if (rand(4) === 0) player.hair.color = "sandy brown";
					else if (rand(3) === 0) player.hair.color = "silver";
					else if (rand(2) === 0) player.hair.color = "white";
					else player.hair.color = "brown";
					outputText(".");
				}
				player.skin.type = Skin.FUR;
				player.skin.furColor = player.hair.color;
				player.underBody.restore(); // Restore the underbody for now
				outputText("  <b>You now have " + player.skin.furColor + " fur!</b>");
				changes++;
			}
			//Tail TFs!
			if (player.tail.type !== Tail.FERRET && player.ears.type === Ears.FERRET && rand(3) === 0 && changes < changeLimit)
			{
				//If ears are ferret, no tail:
				if (player.tail.type === Tail.NONE)
				{
					outputText("\n\nYou slump to the ground as you feel your spine lengthening and twisting, sprouting fur as it finishes growing.  Luckily the new growth does not seem to have ruined your [armor].  <b>You now have a ferret tail!</b>");
				}
				//Placeholder for any future TFs that will need to be made compatible with this one
				//centaur, has ferret ears:
				else if (player.tail.type === Tail.HORSE && player.isTaur()) outputText("\n\nYou shiver as the wind gets to your tail, all of its shiny bristles having fallen out.  Your tail then begins to lengthen, warming back up as it sprouts a new, shaggier coat of fur.  This new, mismatched tail looks a bit odd on your horse lower body.  <b>You now have a ferret tail!</b>");
				//If tail is harpy, has ferret ears:
				else if (player.tail.type === Tail.HARPY) outputText("\n\nYou feel a soft tingle as your tail feathers fall out one by one.  The little stump that once held the feathers down begins to twist and lengthen before sprouting soft, fluffy fur.  <b>You now have a ferret tail!</b>");
				//If tail is bunny, has ferret ears:
				else if (player.tail.type === Tail.RABBIT) outputText("\n\nYou feel a pressure at the base of your tiny, poofy bunny tail as it begins to lengthen, gaining at least another foot in length.  <b>You now have a ferret tail!</b>");
				//If tail is reptilian/draconic, has ferret ears:
				else if (player.tail.type === Tail.DRACONIC || player.tail.type === Tail.LIZARD) outputText("\n\nYou reach a hand behind yourself to rub at your backside as your tail begins to twist and warp, becoming much thinner than before.  It then sprouts a thick coat of fur.  <b>You now have a ferret tail!</b>");
				//If tail is cow, has ferret ears:
				else if (player.tail.type === Tail.COW) outputText("\n\nYour tail begins to itch slightly as the poof at the end of your tail begins to spread across its entire surface, making all of its fur much more dense than it was before. It also loses a tiny bit of its former length. <b>You now have a ferret tail!</b>");
				//If tail is cat, has ferret ears:
				else if (player.tail.type === Tail.CAT) outputText("\n\nYour tail begins to itch as its fur becomes much denser than it was before.  It also loses a tiny bit of its former length.  <b>You now have a ferret tail!</b>");
				//If tail is dog, has ferret ears:
				else if (player.tail.type === Tail.DOG) outputText("\n\nSomething about your tail feels... different.  You reach behind yourself, feeling it.  It feels a bit floppier than it was before, and the fur seems to have become a little more dense.  <b>You now have a ferret tail!</b>");
				//If tail is kangaroo, has ferret ears:
				else if (player.tail.type === Tail.KANGAROO) outputText("\n\nYour tail becomes uncomfortably tight as the entirety of its length begins to lose a lot of its former thickness.  The general shape remains tapered, but its fur has become much more dense and shaggy.  <b>You now have a ferret tail!</b>");
				//If tail is fox, has ferret ears:
				else if (player.tail.type === Tail.FOX) outputText("\n\nYour tail begins to itch as its fur loses a lot of its former density.  It also appears to have lost a bit of length.  <b>You now have a ferret tail!</b>");
				//If tail is raccoon, has ferret ears:
				else if (player.tail.type === Tail.RACCOON) outputText("\n\nYour tail begins to itch as its fur loses a lot of its former density, losing its trademark ring pattern as well.  It also appears to have lost a bit of length.  <b>You now have a ferret tail!</b>");
				//If tail is horse, has ferret ears:
				else if (player.tail.type === Tail.HORSE) outputText("\n\nYou shiver as the wind gets to your tail, all of its shiny bristles having fallen out.  Your tail then begins to lengthen, warming back up as it sprouts a new, shaggier coat of fur.  <b>You now have a ferret tail!</b>");
				//If tail is mouse, has ferret ears:
				else if (player.tail.type === Tail.MOUSE) outputText("\n\nYour tail begins to itch as its bald surface begins to sprout a thick layer of fur.  It also appears to have lost a bit of its former length.  <b>You now have a ferret tail!</b>");
				else outputText("\n\nYour tail begins to itch a moment before it starts writhing, your back muscles spasming as it changes shape. Before you know it, <b>your tail has reformed into a narrow, ferret's tail.</b>");
				player.tail.type = Tail.FERRET;
				changes++;
			}
			//If legs are not ferret, has ferret ears and tail
			if (player.lowerBody.type !== LowerBody.FERRET && player.ears.type === Ears.FERRET && player.tail.type === Tail.FERRET && rand(4) === 0 && changes < changeLimit)
			{
				//-If centaur, has ferret ears and tail:
				if (player.isTaur()) {
					outputText("\n\nYou legs tremble, forcing you to lie on the ground, as they don't seems to answer you anymore."
					          +" A burning sensation in them is the last thing you remember before briefly blacking out. When it subsides"
					          +" and you finally awaken, you look at them again, only to see that you’ve left with a single set of digitigrade legs,"
					          +" and a much more humanoid backside. Soon enough, the feeling returns to your reformed legs, only to come with an"
					          +" itching sensation. A thick [if (hasFurryUnderBody)[underBody.furColor]|black-brown] coat of fur sprouts from them."
					          +" It’s soft and fluffy to the touch. Cute pink paw pads complete the transformation."
					          +" <b>Seems like you’ve gained a set of ferret paws!</b>");
				} else {
					switch (player.lowerBody.type) {
						case LowerBody.NAGA:
							outputText("\n\nA strange feeling in your tail makes you have to lay on the ground. Then, the feeling becomes stronger,"
							          +" as you feel an increasing pain in the middle of your coils. You gaze at them for a second, only to realize"
							          +" that they’re dividing! In a matter of seconds, they’ve reformed into a more traditional set of legs,"
							          +" with the peculiarity being that they’re fully digitigrade in shape. Soon, every scale on them falls off to"
							          +" leave soft [skin] behind. That doesn’t last long, because soon a thick coat of"
							          +" [if (hasFurryUnderBody)[underBody.furColor]|black-brown] fur covers them."
							          +" It feels soft and fluffy to the touch. Cute pink paw pads complete the transformation."
							          +" <b>Seems like you’ve gained a set of ferret paws!</b>");
							break;

						case LowerBody.GOO:
							outputText("\n\nYour usually fluid gooey appendage becomes strangely rigid, forcing you to stay still as you are."
							          +" Then, in front of your eyes, you see how the goo on it concentrates and shapes into the usual shape of two"
							          +" legs. Faster than you can would’ve imagined, the fluid turns into solid bones, that are instantly enveloped"
							          +" by tissues, nerves and muscles, only to be finally covered in a layer of soft, human-looking skin."
							          +" You test your re-gained feet, smiling when discovering"
							          +" that you can use them as before without major issue.");
							outputText("\n\nThen, a feeling of unease forces you to sit on a nearby rock, as you feel something within your [feet]"
							          +" is changing. Numbness overcomes them, as muscles and bones change, softly shifting, melding and rearranging"
							          +" themselves. After a couple of minutes, they leave you with a set of digitigrade legs with pink pawpads,"
							          +" ending in short black claws and covered in a thick layer of"
							          +"  fur. It feels quite soft and fluffy."
							          +" <b>You’ve gained a set of ferret paws!</b>");
							break;

						case LowerBody.DRIDER:
							outputText("\n\nYou eight spider-like legs tremble, forcing you to lie on the ground, as they doesn't seem to answer"
							          +" you anymore. A burning sensation in them is the last thing you remember before briefly blacking out."
							          +" When it subsides and you finally awaken, you look at them again, only to see that you’ve left with a single"
							          +" set of digitigrade legs. Soon enough, the feeling returns to your reformed legs, only to come with an"
							          +" itching sensation. A thick [if (hasFurryUnderBody)[underBody.furColor]|black-brown] coat of fur"
							          +" sprouts from them. It’s soft and fluffy to the touch. Cute pink paw pads complete the transformation."
							          +" <b>Seems like you’ve gained a set of ferret paws!</b>");
							break;

						case LowerBody.HUMAN:
						case LowerBody.HOOFED:
						case LowerBody.CLOVEN_HOOFED:
						case LowerBody.DEMONIC_CLAWS:
						case LowerBody.DEMONIC_HIGH_HEELS:
						default:
							outputText("\n\nA feeling of unease forces you to sit on a nearby rock, as you feel something within your [feet]"
							          +" is changing. Numbness overcomes them, as muscles and bones change, softly shifting, melding and rearranging"
							          +" themselves. After a couple of minutes, they leave you with a set of digitigrade legs with pink pawpads,"
							          +" ending in short black claws and covered in a thick layer of"
							          +" [if (hasFurryUnderBody)[underBody.furColor]|black-brown] fur. It feels quite soft and fluffy."
							          +" <b>You’ve gained a set of ferret paws!</b>");
					}
				}
				changes++;
				player.lowerBody.type = LowerBody.FERRET;
				player.lowerBody.legCount = 2;
			}
			//Arms
			if (player.arms.type !== Arms.FERRET && player.tail.type === Tail.FERRET && player.lowerBody.type === LowerBody.FERRET && rand(4) === 0 && changes < changeLimit)
			{
				outputText("\n\nWeakness overcomes your arms, and no matter what you do, you can’t muster the strength to raise or move them."
				          +" Did the fruit had some drug-like effects? Sitting on the ground, you wait for the limpness to end. As you do so,"
				          +" you realize that the bones at your hands are changing, as well as the muscles on your arms. They’re soon covered,"
				          +" from the shoulders to the tip of your digits, on a layer of soft,"
				          +" fluffy [if (hasFurryUnderBody)[underBody.furColor]|black-brown] fur. Your hands gain pink, padded paws where your palms"
				          +" were once, and your nails become short claws, not sharp enough to tear flesh, but nimble enough to make climbing and"
				          +" exploring much easier. <b>Your arms have become like those of  a ferret!</b>");
				player.arms.type = Arms.FERRET;
				mutations.updateClaws(Claws.FERRET);
				changes++;
			}
			//If ears are not ferret:
			if (player.ears.type !== Ears.FERRET && rand(4) === 0 && changes < changeLimit)
			{
				outputText("\n\nYour ears twitch under the fruit transformative effects, and your hearing is diminished for a while when they change."
				          +" As uncomfortable as it is, the process, luckily, doesn’t take too much time. The flesh on your ears shift and merges"
				          +" into a couple of small, round ones. Then, [furColor] fur sprouts over them, as they locate themselves at the sides of"
				          +" your head, ready to detect any nearby sound. At the end, you’re left with a pair of ferret ears, quite animalistic on"
				          +" their shape and looks. <b>You’ve got ferret ears!</b>");
				player.ears.type = Ears.FERRET;
				changes++;
			}
			//Remove antennae, if insectile
			if (player.hasInsectAntennae() && rand(4) === 0 && changes < changeLimit)
			{
				outputText("\n\nThe antennae parting your hair become suddenly numb, no doubt due the fruit effects, and they become thinner"
				          +" and thinner. When they’re almost hair-width, the remaining flesh on them reabsorbs itself on your head."
				          +" Seems like <b>your antennae are gone</b>.");
				player.antennae.type = Antennae.NONE;
				changes++;
			}
			//If no other effect occurred, fatigue decreases:
			if (changes === 0)
			{
				outputText("\n\nYour eyes widen.  With the consumption of the fruit, you feel much more energetic.  You’re wide awake now!");
				changes++;
				player.changeFatigue(-10);
			}
			player.refillHunger(20);
			flags[kFLAGS.TIMES_TRANSFORMED] += changes;
			
			return false;
		}
	}
}
