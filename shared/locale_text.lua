-- Private lookup for copy owned by this resource, even inside compatibility exports.
function CoreLang(key, ...)
    return Kora.locale.translate('kora_core', key, ...)
end
