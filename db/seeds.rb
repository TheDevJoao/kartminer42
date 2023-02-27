# Creates the tournament
tournament = Tournament.create(name: 'Kartminer42')

# Creates the races
race1 = Race.create(date: Date.current - 1.day, place: 'Mushroom Kingdom', tournament:)
race2 = Race.create(date: Date.current - 30.days, place: 'Hyrule Kingdom', tournament:)

# Creates the racers
racer1 = Racer.create(name: 'Joao Pedro', born_at: Date.current - 28.years)
racer2 = Racer.create(name: 'Coder man', born_at: Date.current - 20.years)
racer3 = Racer.create(name: 'Hacker man', born_at: Date.current - 19.years)
racer4 = Racer.create(name: 'Mario', born_at: Date.current - 60.years)
racer5 = Racer.create(name: 'Bowser', born_at: Date.current - 65.years)

# Creates the placements
Placement.create(racer: racer1, race: race1, position: 3)
Placement.create(racer: racer2, race: race1, position: 1)
Placement.create(racer: racer3, race: race1, position: 2)
Placement.create(racer: racer4, race: race1, position: 4)
Placement.create(racer: racer5, race: race1, position: 5)

Placement.create(racer: racer1, race: race2, position: 5)
Placement.create(racer: racer2, race: race2, position: 3)
Placement.create(racer: racer3, race: race2, position: 4)
Placement.create(racer: racer4, race: race2, position: 1)
Placement.create(racer: racer5, race: race2, position: 2)
