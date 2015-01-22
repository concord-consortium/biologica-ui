describe 'Basics', ->
  it 'can create a dragon', ->
    org = new BioLogica.Organism(BioLogica.Species.Dragon, "a:h,b:h", BioLogica.FEMALE)

    expect(org.sex).toEqual BioLogica.FEMALE
    expect(org.species.name).toEqual 'Dragon'
    expect(org.getCharacteristic('horns')).toEqual 'Horns'

