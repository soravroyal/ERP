define(
({
  viewer:{
    main:{
      scaleBarUnits: "metric" //"english (for miles) or "metric" (for km) - don't translate.
    },
    errors:{
      createMap: "לא ניתן ליצור מפה",
      bitly: 'ה- bitly משתמש לקיצור של ה- url לשיתוף. קרא את קובץ ה- readme לפרטים על איך ליצור ולהשתמש במפתח bitly',
      general: "שגיאה"
    }
  },
  tools:{
    basemap: {
    title: "החלף מפת בסיס",
    label: "מפת בסיס"
    },
    print: {
    layouts:{
      label1: 'לרוחב (PDF)',
      label2: 'לאורך (PDF)',
      label3: 'לרוחב (Image)',
      label4: 'לאורך (Image)'
    },
    title: "הדפס מפה",
    label: "הדפס"
    },
    share: {
    title: "שתף מפה",
    label: "שתף",
    menu:{
      facebook:{
        label: "פייסבוק"
       },
      twitter:{
        label: "טוויטר"
      },
      email:{
        label: "Email",
        message: "בדוק מפה זו"
      }    
    }
    },
    measure: {
      title: "מדידה",
      label: "מדידה"
    },
    time: {
      title: "הצג סרגל זמן",
      label: "זמן",
      timeRange: "<b>טווח זמן: </b> ${start_time} עד ${end_time}",
      timeRangeSingle: "<b>טווח זמן: </b> ${time}"
    },
    editor: {
      title: "הצג עורך",
      label: "עורך"
    },
    legend: {
      title: "הצג מקרא",
      label: "מקרא"
    },
    details: {
      title: "הצג פרטי מפה",
      label: "פרטים"
    },
    bookmark:{
      title: "הצג סימניות",
      label: "סימניות",
      details: "לחץ על סימניה כדי לנווט למיקום"
    },
    layers: {
      title: "הצג רשימת שכבה",
      label: "שכבות"
    },
    search: {
      title: "מצא כתובת או מקום",
      errors:{
       missingLocation: "לא נמצא מיקום"
      }
    }
  },
  panel:{
    close:{
      title: "לוח סגור",
      label: "סגור"
    }
  }
})
);