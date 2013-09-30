define(
({
  viewer:{
    main:{
      scaleBarUnits: "metric" //"english (for miles) or "metric" (for km) - don't translate.
    },
    errors:{
      createMap: "Não foi possível criar o mapa",
      bitly: 'O bitly é utilizado para encurtar a url de partilha. Consulte o ficheiro Leia-Me para obter mais detalhes sobre criar e utilizar a chave bitly',
      general: "Erro"
    }
  },
  tools:{
    basemap: {
    title: "Mudar Mapa Base",
    label: "Mapa Base"
    },
    print: {
    layouts:{
      label1: 'Paisagem (PDF)',
      label2: 'Retrato (PDF)',
      label3: 'Paisagem (imagem)',
      label4: 'Retrato (imagem)'
    },
    title: "Imprimir Mapa",
    label: "Imprimir"
    },
    share: {
    title: "Partilhar Mapa",
    label: "Partilhar",
    menu:{
      facebook:{
        label: "Facebook"
       },
      twitter:{
        label: "Twitter"
      },
      email:{
        label: "Correio eletrónico",
        message: "Consulte este mapa"
      }    
    }
    },
    measure: {
      title: "Medir",
      label: "Medir"
    },
    time: {
      title: "Exibir Controlo do Tempo",
      label: "Tempo",
      timeRange: "<b>Intervalo de Tempo:</b> ${start_time} até ${end_time}",
      timeRangeSingle: "<b>Intervalo de Tempo:</b> ${time}"
    },
    editor: {
      title: "Exibir Editor",
      label: "Editor"
    },
    legend: {
      title: "Exibir Legenda",
      label: "Legenda"
    },
    details: {
      title: "Exibir Detalhes do Mapa",
      label: "Detalhes"
    },
    bookmark:{
      title: "Exibir Marcadores",
      label: "Marcadores",
      details: "Clique num marcador para navegar até o local"
    },
    layers: {
      title: "Exibir lista de camadas",
      label: "Camadas"
    },
    search: {
      title: "Localizar endereço ou lugar",
      errors:{
       missingLocation: "Local não encontrado"
      }
    }
  },
  panel:{
    close:{
      title: "Fechar Painel",
      label: "Fechar"
    }
  }
})
);