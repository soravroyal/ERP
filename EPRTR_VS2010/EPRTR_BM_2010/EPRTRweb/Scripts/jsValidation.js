function PRTValidation() {

    // The controls used are found
    var clIDchkAir = document.getElementById('clIDchkAir').value;
    var chkAir = document.getElementById(clIDchkAir);
    var clIDchkWater = document.getElementById('clIDchkWater').value;
    var chkWater = document.getElementById(clIDchkWater);
    var clIDchkSoil = document.getElementById('clIDchkSoil').value;
    var chkSoil = document.getElementById(clIDchkSoil);

    // Accidental checkbox is not always present
    var chkAccidentalObj = document.getElementById('clIDchkAccidental');
    if (chkAccidentalObj) {
        var clIDchkAccidental = chkAccidentalObj.value;
        var chkAccidental = document.getElementById(clIDchkAccidental);
        
        // Accidental can not be chosen if neither Air, Water or Soil is chosen
        if (!chkAir.checked && !chkWater.checked && !chkSoil.checked) {
            chkAccidental.checked = false;
            chkAccidental.disabled = true;
        }
        else {
            chkAccidental.disabled = false;
        }
    }

    // Warning is dependant on wether 3 or 4 checkboxes must be selected
    document.getElementById("msgPRTValidation").style.display = 'none';
    var WasteWaterObj = document.getElementById('clIDchkWasteWater');
    if (WasteWaterObj) {
        var clIDchkWasteWater = document.getElementById('clIDchkWasteWater').value;
        var chkWasteWater = document.getElementById(clIDchkWasteWater);

        // Warning if search will yield no results
        if (!chkAir.checked && !chkWater.checked && !chkSoil.checked && !chkWasteWater.checked) {
            document.getElementById("msgPRTValidation").style.display = 'block';
        }
    }
    else {
        // Warning if search will yield no results
        if (!chkAir.checked && !chkWater.checked && !chkSoil.checked) {
            document.getElementById("msgPRTValidation").style.display = 'block';
        }
    }
}

function PRTLoadValidation() {

    // Accidental checkbox is not always present
    chkAccidentalObj = document.getElementById('clIDchkAccidental');
    if (chkAccidentalObj) {
        // The controls used are found
        var clIDchkAir = document.getElementById('clIDchkAir').value;
        var chkAir = document.getElementById(clIDchkAir);
        var clIDchkWater = document.getElementById('clIDchkWater').value;
        var chkWater = document.getElementById(clIDchkWater);
        var clIDchkSoil = document.getElementById('clIDchkSoil').value;
        var chkSoil = document.getElementById(clIDchkSoil);

        var clIDchkAccidental = chkAccidentalObj.value;
        var chkAccidental = document.getElementById(clIDchkAccidental);

        // Accidental can not be chosen if neither Air, Water or Soil is chosen
        if (!chkAir.checked && !chkWater.checked && !chkSoil.checked) {
            chkAccidental.checked = false;
            chkAccidental.disabled = true;
        }
    }
}

function WTValidation() {

    // As standard the validation msg is hidden
    document.getElementById("msgWasteValidation").style.display = 'none';

    // The waste type controls used are found and validated. If one of them present they will all be
    if (document.getElementById('clIDchkWasteNonHazardous') != null) {
        var clIDchkWasteNonHazardous = document.getElementById('clIDchkWasteNonHazardous').value;
        var chkWasteNonHazardous = document.getElementById(clIDchkWasteNonHazardous);
        var clIDchkWasteHazardousCountry = document.getElementById('clIDchkWasteHazardousCountry').value;
        var chkWasteHazardousCountry = document.getElementById(clIDchkWasteHazardousCountry);
        var clIDchkWasteHazardousTransboundary = document.getElementById('clIDchkWasteHazardousTransboundary').value;
        var chkWasteHazardousTransboundary = document.getElementById(clIDchkWasteHazardousTransboundary);

        // to see if validation msg must be shown
        if (!chkWasteNonHazardous.checked && !chkWasteHazardousCountry.checked && !chkWasteHazardousTransboundary.checked) {
            document.getElementById("msgWasteValidation").style.display = 'block';
        }
    }

    // The treatment controls used are found and validated. If one of them present they will all be.
    if (document.getElementById('clIDchkTreatmentRecovery') != null) {
        var clIDchkTreatmentRecovery = document.getElementById('clIDchkTreatmentRecovery').value;
        var chkTreatmentRecovery = document.getElementById(clIDchkTreatmentRecovery);
        var clIDchkTreatmentDisposal = document.getElementById('clIDchkTreatmentDisposal').value;
        var chkTreatmentDisposal = document.getElementById(clIDchkTreatmentDisposal);
        var clIDchkTreatmentUnspecified = document.getElementById('clIDchkTreatmentUnspecified').value;
        var chkTreatmentUnspecified = document.getElementById(clIDchkTreatmentUnspecified);

        // to see if validation msg must be shown
        if (!chkTreatmentRecovery.checked && !chkTreatmentDisposal.checked && !chkTreatmentUnspecified.checked) {
            document.getElementById("msgWasteValidation").style.display = 'block';
        }
    }
}
