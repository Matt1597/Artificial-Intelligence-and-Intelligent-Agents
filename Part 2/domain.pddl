(define (domain domain1)
    (:requirements
        :strips :equality :typing
    )
    
   (:types
        ship
        deck
        planet
        belt
    	room
		person
	    rocks
	    plasma_ore
	    light_equipment
        heavy_equipment
		robot
    	moving
    )
    
    (:predicates
        (location ?l)
        (asteroid_belt ?a)
        (damaged ?u)
        (recharged ?re)
        (injured ?ij)
        (healthy ?heal)
        (hostile ?hos)
        (visited ?v)
        (medical_personnel ?m)
        (medical_equipment ?me)
        (rover ?ro)
        (explored ?ex)
        (comms_station ?cs)


        (level ?x ?y)
        (resource ?re ?p)
        (path ?x ?y)
		(loc ?s ?l)
		(at ?x ?l)
        (on ?s ?p)
        (route ?x ?y)
        (lift ?x ?y)
    )

;
;The captain can order the ship to travel to a given destination, provided the captain is on the bridge.
;The ship can travel to another location provided it isn't damaged and there is a navigator on the bridge who has been given an appropriate order
;
(:action move_ship
    :parameters
        (?s - ship ?p - planet ?b - planet)
    :precondition
		(and
			(on ?s ?p)
			(route ?p ?b)
			(not (asteroid_belt ?b))
            (not (damaged ?s))
			(or (loc captain bridge)
			    (loc navigator bridge))
		)
    :effect
        (and
            (not (on ?s ?p))
            (on ?s ?b)
		)
    )
    
;    
;Travelling to a planet that is in an asteroid belt damages the ship.
;
(:action damage_move_ship
    :parameters
        (?s - ship ?p - planet ?b - planet)
    :precondition
		(and
			(on ?s ?p)
			(route ?p ?b)
			(not (damaged ?s))
			(asteroid_belt ?b)
			(or (loc captain bridge)
			    (loc navigator bridge)
			)
		)
    :effect
        (and
            (not (on ?s ?p))
            (on ?s ?b)
            (damaged ?s)
		)
    )

;   
;Engineers can fix the ship from engineering.
;
(:action fix_ship_machine
    :parameters
        (?s)
    :precondition
		(and
		    (damaged ?s)
		    (loc engineer engineering)
		)
    :effect
        (and
            (not (damaged ?s))
		)
    )

;
;Personnel can move around a deck provided the rooms on the deck are connected by doors.
;
(:action move_room
    :parameters
        (?h - person ?p - room ?b - room)
    :precondition
		(and
			(loc ?h ?p)
			(path ?p ?b)
			)
    :effect
        (and
            (not (loc ?h ?p))
            (loc ?h ?b)
		)
    )
    
;
;Personnel can move between decks by using one of the lifts that are scattered around the ship.
;
(:action move_lift
    :parameters
        (?h - person ?p - room ?b - room)
    :precondition
		(and
			(loc ?h ?p)
			(lift ?p ?b)
			)
    :effect
        (and
            (not (loc ?h ?p))
            (loc ?h ?b)
		)
    )
   
;
;Personnel can transport to/from a planet from the transporter room.
;
(:action person_move_prep
    :parameters
        (?h - person ?b - room)
    :precondition
        (and
            (loc ?h ?b)
            (not (loc ?h transporter_room))
            (or (path ?b transporter_room)
                (path transporter_room ?b)
            )
        )
    :effect
    (and
            (not (loc ?h ?b))
            (loc ?h transporter_room)
		)
	)
(:action person_move_planet
    :parameters
        (?h - person ?p - planet ?b - planet)
    :precondition
		(and
		    (loc ?h transporter_room)
		    (loc transporter transporter_room)
		    (on ship ?p)
		    (route ?p ?b)
		)
    :effect
        (and
            (not (loc ?h ?p))
            (loc ?h ?b)
		)
    )

;
;Small/light equipment can also be transported to/from a planet from the transporter room.
;
(:action lightE_move_prep
    :parameters
        (?e - light_equipment ?b - room)
    :precondition
        (and
            (loc ?e ?b)
            (not (loc ?e transporter_room))
            (or (path ?b transporter_room)
                (path transporter_room ?b)
            )
        )
    :effect
    (and
            (not (loc ?e ?b))
            (loc ?e transporter_room)
		)
	)
(:action lightE_move_planet
    :parameters
        (?e - light_equipment ?p - planet ?b - planet)
    :precondition
		(and
		    (loc ?e transporter_room)
		    (on ship ?p)
		    (loc transporter transporter_room)
		    (route ?p ?b)
		)
    :effect
        (and
            (not (loc ?e ?p))
            (loc ?e ?b)
		)
    )
    
;
;A shuttlecraft can also be used to transport personnel and equipment to and from a planet.
;
(:action shuttlecraft_move_planet
    :parameters
        (?o ?r ?b - planet)
    :precondition
		(and
		    (loc shuttlecraft ?r)
		    (loc ?o ?r)
		    (route ?r ?b)
		)
    :effect
        (and
            (not (loc ?o ?r))
            (on ?o ?b)
		)
    )
    
(:action shuttlecraft_move_back
    :parameters
        (?o ?r ?b - planet)
    :precondition
		(and
		    (loc shuttlecraft ?b)
		    (loc ?o ?b)
		    (route ?b ?r)
		)
    :effect
        (and
            (not (loc ?o ?b))
            (on ?o ?r)
		)
    )

;
;After delivering heavy equipment the robots must recharge.
;The robots can only recharge from the science lab.
;
(:action robot_move_heavy
    :parameters
        (?h - heavy_equipment ?a - room ?b - room)
    :precondition
		(and
		    (loc ?h ?a)
		    (loc robot ?a)
		    (path ?a ?b)
		)
    :effect
        (and
            (not (loc ?h ?a))
            (loc ?h ?b)
            (not (loc robot ?a))
            (loc robot ?b)
            (not (recharged robot))
		)
    )
(:action recharge_robots
    :parameters
        (?t - robot)
    :precondition
		(and
		    (not (recharged ?t))
		    (loc ?t engineering)
		)
    :effect
        (and
            (recharged ?t)
		)
    )
    
;
;Transporting plasma ore to the ship damages the transporter.
;
(:action plasmaore_move
    :parameters
        (?p - plasma_ore ?b ?s)
    :precondition
		(and
		    (loc plasma_ore ?p)
		    (loc transporter ?p)
		    (on ?s ?b)
		    (route ?p ?b)
		)
    :effect
        (and
            (not (loc plasma_ore ?p))
            (not (loc transporter ?p))
            (loc plasma_ore ?s)
            (loc transporter ?s)
            (damaged transporter)
		)
    )
    
;
;Injured crew members can be healed in the sickbay if medical personnel are present.
;
(:action heal_injured
    :parameters
        (?c - person)
    :precondition
		(and
		    (injured ?c)
		    (loc ?c sickbay)
		    (loc medical_personnel sickbay)
		)
    :effect
        (and
            (not (injured ?c))
		)
    )
    
; ><><><><><><><><>< ;
;   RELIEF MISSION   ;
; ><><><><><><><><>< ;
(:action relief_mission
    :parameters
        (?r - room ?s - ship ?b - planet ?p - planet)
    :precondition
		(and
		    (not (healthy ?p))
		    (visited ?p)
		    (on medical_personnel ship)
		    (on medical_equipment ship)
		    (on ship ?b)
		    (not (damaged ship))
		    (route ?b ?p)
		)
	
    :effect
        (and
            (healthy ?p)
            (not (on medical_equipment ship))
            (not (loc medical_equipment ?r))
            (loc medical_equipment ?p)
            (not (on medical_personnel ship))
            (not (loc medical_personnel ?r))
            (loc medical_personnel ?p)
            (not (on ship earth))
            (on ship ?p)
        )
    )

; ><><><><><><><><><><><>< ;
;   FIRST CONTACT MISSION  ;
; ><><><><><><><><><><><>< ;
(:action f_c_friendly
    :parameters
        (?r - room ?p - planet ?b - planet)
    :precondition
		(and
		    (not (visited ?p))
		    (not (hostile ?p))
		    (on ship ?b)
		    (on captain ship)
		    (loc captain bridge)
		    (not (damaged ship))
		    (route ?b ?p)
		)
    :effect
        (and
            (visited ?p)
            (not (on ship ?b))
            (not (loc captain ?r))
            (loc captain ?p)
            (on ship ?p)
            (not (hostile ?p))
		)
    )

(:action f_c_hostile_guards
    :parameters
         (?r - room ?c - person ?p - planet ?b - planet)
    :precondition
		(and
		    (not (visited ?p))
		    (not (damaged ship))
		    (hostile ?p)
		    (on ship ?b)
		    (route ?b ?p)
		    (on captain ship)
		    (on guards ship)
		    (loc captain bridge)
		    ;(loc guards ?r)
		)
    :effect
        (and
            (visited ?p)
            (not (on ship ?b))
            (not (on guards ship))
            (not (loc guards ?r))
            (not (loc captain bridge))
            (loc captain ?p)
            (on guards ?p)
            (on ship ?p)
            (not (hostile ?p))
          ; (loc shuttlecraft ?p)
          ; (not (loc shuttlecraft ?r3))
		)
    )
    
(:action f_c_hostile_noguards
    :parameters
         (?c - person ?p - planet ?b - planet)
	:precondition
		(and
		    (not (visited ?p))
		    (not (damaged ship))
		    (on ship ?b)
		    (route ?b ?p)
		    (hostile ?p)
		    (on captain ship)
		    (not (on ship guards))
		)
    :effect
        (and
            (visited ?p)
            (not (on ship ?b))
            (loc captain ?p)
            (on ship ?p)
            (injured captain)
            (loc shuttlecraft ?p)
		)
    )

; ><><><><><><><><><><><>< ;
;    EXPLATORY MISSION     ;
; ><><><><><><><><><><><>< ;
(:action explore_prep
    :parameters
        (?s - ship ?b - planet ?p - planet)
    :precondition
		(and
		    (not (explored ?p))
		    (on ?s ?b)
		    (not (damaged ?s))
		    (loc rover transporter_room)
		    (loc comms_station transporter_room)
		    (route ?b ?p)
		    (or
		        (resource rocks ?p)
		        (resource plasma_ore ?p)
		    )
		)
	
    :effect
        (and
            (not (loc rover transporter_room))
            (loc rover ?p)
            (not (loc comms_station transporter_room))
            (loc comms_station ?p)
            (not (on ?s earth))
            (on ?s ?p)
        )
    )

(:action retrieve_rocks
    :parameters
        (?s - ship ?b - planet ?p - planet)
    :precondition
		(and
		    (not (loc ship earth))
		    (on ?s ?p)
		    (resource rocks ?p)
            (loc rover ?p)
            (loc comms_station ?p)
		    (route ?p earth)
		)
	
    :effect
        (and
            (on ship earth)
            (explored ?p)
            (not (resource rocks ?p))
            (not (loc rover ?p))
            (loc rover transporter_room)
            (not (loc comms_station ?p))
            (loc comms_station transporter_room)
            (loc rocks science_lab)
        )
    )

(:action retrieve_plasma
    :parameters
        (?s - ship ?p - planet)
    :precondition
		(and
		    (on ?s ?p)
		    (resource plasma_ore ?p)
            (loc rover ?p)
            (loc comms_station ?p)
		    (route ?p earth)
			
		)
	
    :effect
        (and
            (on ship earth)
            (explored ?p)
            (not (resource plasma_ore ?p))
            (not (loc rover ?p))
            (loc rover transporter_room)
            (not (loc comms_station ?p))
            (loc comms_station transporter_room)
            (loc plasma_ore science_lab)
            (damaged transporter)
        )
    )
)
