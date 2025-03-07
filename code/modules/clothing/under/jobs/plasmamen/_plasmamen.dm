/obj/item/clothing/under/plasmaman
	name = "plasma envirosuit"
	desc = "A special containment suit that allows plasma-based lifeforms to exist safely in an oxygenated environment, and automatically extinguishes them in a crisis. Despite being airtight, it's not spaceworthy."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = INFINITY, ACID = INFINITY)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	strip_delay = 80
	icon = 'icons/obj/clothing/species/plasmaman/uniform.dmi'
	species_restricted = list("Plasmaman")
	sprite_sheets = list("Plasmaman" = 'icons/mob/clothing/species/plasmaman/uniform.dmi')
	icon_state = "plasmaman"
	item_state = "plasmaman"
	item_color = "plasmaman"
	dyeable = TRUE
	dyeing_key = DYE_REGISTRY_PLASMAMEN

	var/next_extinguish = 0
	var/extinguish_cooldown = 10 SECONDS
	var/extinguishes_left = 5

/obj/item/clothing/under/plasmaman/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There are [extinguishes_left] extinguisher charges left in this suit.</span>"

/obj/item/clothing/under/plasmaman/proc/Extinguish(mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(H.on_fire)
		if(extinguishes_left)
			if(next_extinguish > world.time)
				return
			next_extinguish = world.time + extinguish_cooldown
			extinguishes_left--
			H.visible_message("<span class='warning'>[H]'s suit automatically extinguishes [H.p_them()]!</span>","<span class='warning'>Your suit automatically extinguishes you.</span>")
			if(!extinguishes_left)
				to_chat(H, "<span class='warning'>Onboard auto-extinguisher depleted, refill with a cartridge.</span>")
			playsound(H.loc, 'sound/effects/spray.ogg', 10, TRUE, -3)
			H.ExtinguishMob()
			new /obj/effect/particle_effect/water(get_turf(H))
	return FALSE

/obj/item/clothing/under/plasmaman/attackby__legacy__attackchain(obj/item/E, mob/user, params)
	if(istype(E, /obj/item/extinguisher_refill))
		if(extinguishes_left == 5)
			to_chat(user, "<span class='notice'>The inbuilt extinguisher is full.</span>")
			return
		else
			extinguishes_left = 5
			to_chat(user, "<span class='notice'>You refill the suit's built-in extinguisher, using up the cartridge.</span>")
			qdel(E)
	else
		return ..()

/obj/item/extinguisher_refill
	name = "envirosuit extinguisher cartridge"
	desc = "A cartridge loaded with a compressed extinguisher mix, used to refill the automatic extinguisher on plasma envirosuits."
	icon_state = "plasmarefill"
	icon = 'icons/obj/device.dmi'
