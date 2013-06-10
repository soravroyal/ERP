// --------------------------------------------------------------------------------------------------
// Open/update popup in new window
// --------------------------------------------------------------------------------------------------
function PopupWindowButtonClicked(popupLink) {
    popupWindow = window.open(popupLink, 'PopupWindow', 'scrollbars=yes,menubar=no,height=600,width=845,resizable=yes,toolbar=no,location=no,status=no,dependent=yes,replace=yes');
    popupWindow.focus();
}
