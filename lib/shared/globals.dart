library tanod_apprehenssion.globals;

Map sort = {
  'Location': false,
  'Date': true,
};

Map filters = {
  'Category': {
    'Latest': false,
    'Dropped': false,
    'Tagged': false,
  },
  'Date': {
    'Start': false,
    'End': false,
  },
  'Area': {
    'Tarape\'s Store': false,
    'ShopStrutt.ph': false,
    'Melchor\'s Store': false,
  }
};

DateTime? start;
DateTime? end;
// String selectedArea = "Tarape\'s Store";
String selectedLocation = "N/A";
