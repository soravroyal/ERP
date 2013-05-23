
// Functions used to store a cookie
function setCookie(c_name, value, expiredays) {
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + expiredays);
    document.cookie = c_name + "=" + escape(value) +
((expiredays == null) ? "" : ";expires=" + exdate.toGMTString() + "; path=/");
}

// Functions used to store language parameter
function StoreLanguage(linkButton) {

    var langCode = linkButton.attributes['langcode'].value;

    // cookie lives one year
    setCookie("Culture", langCode, 365);

    // reload page to reset all controls
    document.location.reload();
}