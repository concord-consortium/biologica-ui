Events = require 'events'
EventTypes = require 'event-types'

module.exports = class DragonChromosomePulldownView
  constructor: (@dragon, domId, {@hiddenGenes, @hiddenAlleles})->
    @hiddenAlleles ?= []
    @hiddenGenes ?= []
    @div = $(domId)[0]
    @species = BioLogica.Species.Dragon

    @_injectHtml()

  _injectHtml: ->
    for chromo in @species.chromosomeNames
      genes = @species.chromosomeGeneMap[chromo].map (allele)=> @dragon.genetics.geneForAllele(allele)

      for side in ['A','B']
        @_injectChromosome(chromo, side, genes)

  _injectChromosome: (chromo, side, genes)->
    chromoLabel = @_chromoLabel(chromo, side)
    bioChromosome = @dragon.genetics.genotype.chromosomes[chromo][@_biologicaSide(chromo, side)]

    chromoElem = document.createElement 'div'
    chromoElem.classList.add 'chromosome'
    chromoElem.classList.add chromoLabel
    chromoElem.classList.add side

    labelElem = document.createElement 'div'
    labelElem.classList.add 'chromosome-label'
    labelElem.innerHTML = 'Chromosome: ' + chromoLabel
    chromoElem.appendChild(labelElem)

    imageElem = document.createElement 'img'
    imageElem.classList.add 'chromosome-image'
    imageElem.src = "images/dragons/chromosomes/#{chromoLabel}#{side}.png"
    chromoElem.appendChild imageElem

    unless chromo is 'XY' and side is 'B' and @dragon.sex is BioLogica.MALE
      # Allele pulldowns
      for gene in genes
        continue if gene in @hiddenGenes
        sel = document.createElement 'select'
        sel.name = "#{chromoLabel}#{side}-#{gene}"
        sel.classList.add gene
        chromoElem.appendChild sel
        for allele in @species.geneList[gene].alleles
          continue if allele in @hiddenAlleles
          opt = document.createElement 'option'
          opt.value = allele
          opt.innerHTML = allele
          if allele in bioChromosome.alleles
            $(opt).prop('selected', true)
            $(sel).data('previous', allele)
          sel.appendChild opt

        $(sel).data('previous', @species.geneList[gene].alleles[0]) unless $(sel).data('previous')?
        $(sel).change (evt)=>
          newVal = $(evt.target).val()
          oldVal = $(evt.target).data('previous')
          @dragon.genetics.genotype.replaceAllele(bioChromosome, oldVal, newVal)
          @dragon.resetPhenotype()
          $(evt.target).data('previous', newVal)
          Events.dispatchEvent EventTypes.DRAGON.ALLELES_CHANGED, {dragon: @dragon, source: @, oldVal: oldVal, newVal: newVal, chromosome: chromo, side: side}


    @div.appendChild chromoElem

  _chromoLabel: (chromo, side)->
    chromoLabel = chromo
    if chromo is 'XY'
      if side is 'A'
        chromoLabel = 'X'
      else if @dragon.sex is BioLogica.MALE
        chromoLabel = 'Y'
      else
        chromoLabel = 'X'

    return chromoLabel

  _biologicaSide: (chromo, side)->
    if chromo is 'XY'
      if @dragon.sex is BioLogica.FEMALE
        return if side is 'A' then 'x1' else 'x2'
      else
        return if side is 'A' then 'x' else 'y'
    else
      return side.toLowerCase()

    # <div class='chromosome left'>
    #   <div class='chromosome-label'>Chromosome: 1</div>
    #   <img class='chromosome-image' src="images/dragons/chromosomes/1A.png" />
    #   <select class='horns'>
    #     <option>H</option>
    #     <option>h</option>
    #     <option>HU</option>
    #   </select>
    #   <select class='scales'>
    #     <option>S</option>
    #     <option>s</option>
    #   </select>
    # </div>

