module.exports = class MeiosisSupport
  @EVENTS:
    GAMETE_SELECTED: 'meiosis.gamete-selected'
    RESET: 'meiosis.retry'
    OFFSPRING_CREATED: 'meiosis.offspring-created'

  @processAlleleString: (alleleString, species=BioLogica.Species.Dragon) ->
    return [] unless alleleString?

    species.genesToChromosome ?= @generateGeneToChromosomeMap(species)
    map = species.genesToChromosome
    alleleSet = alleleString.split(/,/)
    alleles = {}
    for rawAllele in alleleSet
      [side, allele] = rawAllele.split(/:/)
      gene = BioLogica.Genetics.getGeneOfAllele(species, allele).name
      chromo = ""+map[gene]
      chromo = 'X' if chromo is 'XY'
      side = side.toUpperCase()

      if not alleles[chromo]?[side]?
        values = [allele]
        alleles[chromo] ?= {}
        alleles[chromo][side] = values;
      else
        alleles[chromo][side].push(allele)

    return alleles

  @generateGeneToChromosomeMap: (species) ->
    map = {}
    for chromo, alleles of species.chromosomeGeneMap
      for allele in alleles
        gene = BioLogica.Genetics.getGeneOfAllele(species, allele).name
        map[gene] = chromo
    return map

  @allelesToJSON: (alleleString) ->
    return null unless alleleString?

    genetics = @processAlleleString(alleleString)
    console.log(genetics)

    chromosomesArr = []
    for own chromo,sides of genetics
      for own side,alleles of sides
        allelesArr = []
        for allele in alleles
          alleleDef =
            sex: if side is 'A' then 'female' else 'male'
            gene: allele
          allelesArr.push(alleleDef)

        chromosomesArr.push({ alleles: allelesArr})

      if not sides.B?
        # fake some B side info so the chromosome looks ok
        chromosomesArr.push({ alleles: [{ sex: "male", gene: "" },{ sex: "male", gene: "" }]})

    return { chromosomes: chromosomesArr }

  @JSONToAlleles: (motherJson, fatherJson) ->
    outString = ""

    motherString = @_JSONToAlleles(motherJson, "a:")
    fatherString = @_JSONToAlleles(fatherJson, "b:")

    return motherString + fatherString

  @_JSONToAlleles: (json, prefix) ->
    outString = ""
    for chromo in json.chromosomes
      for allele in chromo.alleles
        outString += prefix + allele.gene + ","
    return outString

  @getOffspringSex: (fatherChromosomes) ->
    lastChromoAlleles = fatherChromosomes.chromosomes[2].alleles
    sex = BioLogica.FEMALE
    if lastChromoAlleles.length < 1 or lastChromoAlleles[0].gene is "" or lastChromoAlleles[0].gene is 'Y'
      sex = BioLogica.MALE
    return sex
