define(
({
  viewer:{
    main:{
      scaleBarUnits: "metric" //"english (for miles) or "metric" (for km) - don't translate.
    },
    errors:{
      createMap: "Kan ikke oprette kort",
      bitly: 'bitly bruges til at forkorte webadressen med henblik på deling. Se readme-filen for oplysninger om at oprette og bruge en bitly-nøgle',
      general: "Fejl"
    }
  },
  tools:{
    basemap: {
    title: "Skift baggrundskort",
    label: "Baggrundskort"
    },
    print: {
    layouts:{
      label1: 'På langs (PDF)',
      label2: 'På højkant (PDF)',
      label3: 'På langs (billede)',
      label4: 'På højkant (billede)'
    },
    title: "Udskriv kort",
    label: "Udskriv"
    },
    share: {
    title: "Del kort",
    label: "Del",
    menu:{
      facebook:{
        label: "Facebook"
       },
      twitter:{
        label: "Twitter"
      },
      email:{
        label: "E-mail",
        message: "Se dette kort"
      }    
    }
    },
    measure: {
      title: "Mål",
      label: "Mål"
    },
    time: {
      title: "Vis tidsskyderen",
      label: "Tid",
      timeRange: "<b>Tidsrum:</b> ${start_time} til ${end_time}",
      timeRangeSingle: "<b>Tidsrum:</b> ${time}"
    },
    editor: {
      title: "Vis redigering",
      label: "Redigering"
    },
    legend: {
      title: "Vis signaturforklaring",
      label: "Signaturforklaring"
    },
    details: {
      title: "Vis kortoplysninger",
      label: "Oplysninger"
    },
    bookmark:{
      title: "Vis bogmærker",
      label: "Bogmærker",
      details: "Klik på et bogmærke for at navigere til stedet"
    },
    layers: {
      title: "Vis liste over lag",
      label: "Lag"
    },
    search: {
      title: "Find adresse eller sted",
      errors:{
       missingLocation: "Sted ikke fundet"
      }
    }
  },
  panel:{
    close:{
      title: "Luk panel",
      label: "Luk"
    }
  }
})
);