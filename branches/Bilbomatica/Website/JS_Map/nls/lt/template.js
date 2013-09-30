define(
({
  viewer:{
    main:{
      scaleBarUnits: "metric" //"english (for miles) or "metric" (for km) - don't translate.
    },
    errors:{
      createMap: "Žemėlapio sukurti nepavyko",
      bitly: 'bitly naudojamas url trumpinimui bendrinant. Susipažinkite su išsamia informacija, pateikiama faile skaityk (readme) kaip sukurti bitly raktą',
      general: "Klaida"
    }
  },
  tools:{
    basemap: {
    title: "Pakeisti pagrindo žėmėlapį",
    label: "Pagrindo žemėlapis"
    },
    print: {
    layouts:{
      label1: 'Gulsčiai (PDF)',
      label2: 'Stačiai (PDF)',
      label3: 'Gulsčiai (Paveikslėlis)',
      label4: 'Stačiai (Paveikslėlis)'
    },
    title: "Spausdinti žemėlapį",
    label: "Spausdinti"
    },
    share: {
    title: "Bendrinti žemėlapį",
    label: "Bendrinti",
    menu:{
      facebook:{
        label: "Facebook"
       },
      twitter:{
        label: "Twitter"
      },
      email:{
        label: "Elektroninis paštas",
        message: "Išregistruoti šį žemėlapį"
      }    
    }
    },
    measure: {
      title: "Matuoti",
      label: "Matuoti"
    },
    time: {
      title: "Rodyti laiko šliaužiklį",
      label: "Laikas",
      timeRange: "<b>Laiko intervalas:</b> ${start_time} iki ${end_time}",
      timeRangeSingle: "<b>Laiko intervalas:</b> ${time}"
    },
    editor: {
      title: "Rodyti redaktorių",
      label: "Redaktorius"
    },
    legend: {
      title: "Rodyti legendą",
      label: "Legenda"
    },
    details: {
      title: "Rodyti žemėlapio apibūdinimą",
      label: "Išsami informacija"
    },
    bookmark:{
      title: "Rodyti žymes",
      label: "Žymės",
      details: "Perėjimui į vietą, paspauskite žymę"
    },
    layers: {
      title: "Rodyti sluoksnių sąrašą",
      label: "Sluoksniai"
    },
    search: {
      title: "Ieškoti adreso arba vietos",
      errors:{
       missingLocation: "Vieta nerasta"
      }
    }
  },
  panel:{
    close:{
      title: "Uždaryti skydelį",
      label: "Užverti"
    }
  }
})
);