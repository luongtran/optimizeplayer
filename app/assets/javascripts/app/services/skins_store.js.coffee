angular.module('optimizePlayer').factory 'SkinsStore', [ ->
  skins = [
    {
      name: 'Default',
      preview: "player-skin-0.png",
      color: '68, 153, 17',
      selected: false,
      id: 'skin0'
    },
    {
      name: 'Flat Orange Soda',
      preview: "player-skin-1.png",
      color: '221, 81, 37',
      selected: false,
      id: 'skin1'
    },
    {
      name: 'Orange Soda',
      preview: "player-skin-2.png",
      color: '221, 81, 37',
      selected: false,
      id: 'skin2'
    },
    {
      name: 'GrayStation',
      preview: "player-skin-3.png",
      color: '209, 209, 209',
      selected: false,
      id: 'skin3'
    },
    {
      name: 'Titanium',
      preview: "player-skin-4.png",
      color: '209, 209, 209',
      selected: false,
      id: 'skin4'
    },
    {
      name: 'Bumblebee',
      preview: "player-skin-5.png",
      color: '255, 219, 60',
      selected: false,
      id: 'skin5'
    },
    {
      name: 'Polar Ice',
      preview: "player-skin-6.png",
      color: '0, 141, 247',
      selected: false,
      id: 'skin6'
    },
    {
      name: 'Southern Lights',
      preview: "player-skin-7.png",
      color: '0, 141, 247',
      selected: false,
      id: 'skin7'
    },
    {
      name: 'Red Fox',
      preview: "player-skin-8.png",
      color: '205, 75, 63',
      selected: false,
      id: 'skin8'
    },
    {
      name: 'Sunflower',
      preview: "player-skin-9.png",
      color: '255, 230, 60',
      selected: false,
      id: 'skin9'
    },
    {
      name: 'Vimzee',
      preview: "player-skin-10.png",
      color: '76, 135, 211',
      selected: false,
      id: 'skin10'
    },
    # {
    #   name: 'Tube',
    #   preview: "player-skin-11.png",
    #   color: '148, 29, 20',
    #   selected: false,
    #   id: 'skin11'
    # },
  ]
  return {
    skins: skins
  }
]
