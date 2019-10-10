(define (problem problem1)
    (:domain domain1)

    (:objects
		ship - ship
        deck1 deck2 deck3 - deck
        earth mars venus mercury jupiter saturn uranus pluto - planet
        asteroid_belt - belt
		bridge engineering sickbay transporter_room shuttle_bay science_lab cargo_bay - room
		captain navigator engineer science_officers medical_personnel security_person transporter_chief science_officer guards - person
	    plasma_ore - plasma_ore
	    rocks - rocks
        robot - robot
	    lights cameras safety_equipment medical_equipment - light_equipment
	    machinery satellites comms_station - heavy_equipment
		transporter shuttlecraft rover - moving
    )

    (:init  
		(level bridge deck1)
		(level engineering deck1)
		(level sickbay deck2)
		(level transporter_room deck2)
		(level shuttle_bay deck2)
		(level science_lab deck3)
		(level cargo_bay deck3)
		
	   	(path bridge engineering)
	   	(path engineering bridge)
        (path sickbay transporter_room)
        (path transporter_room sickbay)
        (path science_lab cargo_bay)
        (path cargo_bay science_lab)
        (path transporter_room shuttle_bay)
        (path shuttle_bay transporter_room)
        
        (lift bridge sickbay)
        (lift sickbay bridge)
        (lift transporter_room cargo_bay)
        (lift cargo_bay transporter_room)
        
        (asteroid_belt mars)
        (asteroid_belt saturn)
        (asteroid_belt pluto)
		
		(on ship earth)
		(on guards ship)
		
		(on shuttlecraft ship)
		
		(on medical_personnel ship)
		(on medical_equipment ship)
		
		(on deck1 ship)
		(on deck2 ship)
		(on deck3 ship)
		
		(on captain ship)
				
		(route earth mars)
		(route mars earth)
		(route earth venus)
		(route venus earth)
		(route mars saturn)
		(route saturn mars)
		(route venus mercury)
		(route mercury venus)
		(route saturn jupiter)
		(route jupiter saturn)
		(route jupiter uranus)
		(route uranus jupiter)
		(route uranus pluto)
		(route pluto uranus)
		
		(loc captain bridge)
		(loc navigator transporter_room)
		(loc shuttlecraft shuttle_bay)
		(loc engineer engineering)
		(loc medical_personnel sickbay)
		(loc transporter_chief transporter_room)
		
		(damaged ship)
		(recharged robot)
		
		(not (injured captain))
		
		(healthy earth)
		(not (healthy venus))
		(healthy mars)
		(healthy mercury)
		(not (healthy saturn))
		(not (healthy jupiter))
		(not (healthy uranus))
		(not (healthy pluto))
		
		(visited earth)
		(visited mercury)
		(visited mars)
		(not (visited venus))
		(not (visited saturn))
		(not (visited jupiter))
		(not (visited uranus))
		(not (visited pluto))
	
	    (not (hostile mercury))
	    (not (hostile earth))
	    (not (hostile mars))
	    (not (hostile saturn))
		(hostile venus)
		(hostile jupiter)
		(hostile uranus)
		(hostile pluto)
		
		(not (explored venus))
	    (not (explored jupiter))
	    (not (explored uranus))
	    (not (explored pluto))
		(explored mercury)
		(explored earth)
		(not (explored mars))
		(explored saturn)

;
; Heavy equipment is stored in the cargo bay.
; Medical supplies are kept in the sickbay.
;
        (loc lights shuttle_bay) 
		(loc machinery cargo_bay)
		(loc robot shuttle_bay)
		(loc comms_station transporter_room)
		(loc medical_equipment sickbay)
		(loc cameras transporter_room)
		(loc machinery bridge)
		(loc rover transporter_room)
		
		
		(resource rocks mars)
		(resource plasma_ore venus)
		(resource rocks jupiter)
		(resource plasma_ore uranus)
	)

    (:goal
        (and
           ;	(visited uranus)
			;(not (hostile uranus))
			;(on ship pluto)

			;(explored venus)
			;(not (hostile venus))
			;(loc plasma_ore science_lab)
			;(not (damaged transporter))
			;(not (resource plasma_ore venus))

		

			;(loc captain cargo_bay)
			;(loc navigator engineering)
			;(loc engineer bridge)
			

			(loc machinery cargo_bay)
			(recharged robot)
			(visited pluto)
			(on ship mars)
        )
    )
)
