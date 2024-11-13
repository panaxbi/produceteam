var datediff = function (intervalType, first_date, last_date = new Date()) {
    // Parse the input dates
    if (!(first_date && last_date)) return undefined;
    const first = first_date instanceof Date ? first_date : first_date.parseDate();
    const last = last_date instanceof Date ? last_date : last_date.parseDate();
    intervalType = intervalType.replace(/s$/, '');

    // Calculate the difference in milliseconds
    const diffMs = last - first;

    // Convert milliseconds to the specified interval type
    let diffInterval;
    switch (intervalType) {
        case 'year':
            diffInterval = diffMs / (1000 * 60 * 60 * 24 * 365.25);
            break;
        case 'month':
            diffInterval = diffMs / (1000 * 60 * 60 * 24 * 30.44);
            break;
        case 'day':
            diffInterval = diffMs / (1000 * 60 * 60 * 24);
            break;
        case 'hour':
            diffInterval = diffMs / (1000 * 60 * 60);
            break;
        case 'minute':
            diffInterval = diffMs / (1000 * 60);
            break;
        case 'second':
            diffInterval = diffMs / 1000;
            break;
        default:
            throw new Error('Invalid interval type');
    }

    // Return the result rounded to 2 decimal places
    return Math.floor(Math.round(diffInterval * 100) / 100);
}

formatDate = function (date) {
    return new Date((date instanceof Date) && date || Date.parse(`${date}T00:00:00`.replace(/(\d{4})-?(\d{2})-?(\d{2})T/, '$1-$2-$3T')))
}

xo.listener.on(['append::main > :not(slot)[xo-source][xo-stylesheet], body > :not(slot)[xo-source][xo-stylesheet]'], function ({ target }) {
    [...target.children].filter(el => el != this && el.matches && !el.matches(`slot,script,dialog,[role=alertdialog],[role=alert],[role=dialog],[role=status],[role=progressbar],[role=complementary]`)).removeAll()
})
/*
xo.listener.on(['append::html:*[.//@style[contains(.,"view-transition-name")]]'], function ({ target, element }) {
    debugger
})*/

xo.listener.on(`fetch::model[*[@xsi:type="dimension"]]`, function ({ document }) {
    let dimensions = {};
    for (let dimension of document.select(`model/*[@xsi:type="dimension"][row]`)) {
        dimensions[dimension.nodeName] = Object.fromEntries(dimension.select("row").map((row) => [row.getAttributeNode("id") || row.getAttributeNode("key") || row.getAttributeNode("desc"), row.getAttributeNode("desc") || row.getAttributeNode("key") || row.getAttributeNode("id")]));
    }

    let dims = Object.fromEntries(document.select(`model/*[not(@xsi:type="dimension")]/@dim:*`).map(attr => [attr.localName, attr.value]));
    let fks = { ...dims };
    for (let attr of document.select(`model/*[not(@xsi:type="dimension")]/row//@*`).filter(attr => attr.name in fks)) {
        let [dim, key] = fks[attr.name].split(/\//);
        let node = key && (dimensions[dim][attr.value] || attr).parentNode.getAttributeNode(key.replace(/^@/, '')) || (dimensions[dim] || {})[attr.value] || attr;
        attr.value = node.value;
    }
})

xo.listener.on(['fetch', 'Response:failure'], async function ({ settings = {} }) {
    let progress = await settings.progress || [];
    for (let render of progress) {
        let progress = render.querySelector('i progress');
        progress.value = 100;
    }
    progress.remove();
})

Object.defineProperty(xo.session, 'logout', {
    value: async function () {
        try {
            let response = await xover.server.logout();
            for (store in xo.stores) {
                xo.stores[store].remove()
            }
            xover.session.status = 'unauthorized';
        } catch (e) {
            Promise.reject(e);
        }
    }, writable: true, configurable: true
})

xo.listener.on('beforeRender?!store.stylesheets.length::model[not(//processing-instruction())]', function ({ document, store }) {
    let tag = store.tag;
    store.addStylesheet({ href: tag.substring(1).split(/\?/, 1).shift() + '.xslt', target: "@#shell main" });
})

xo.listener.on(['transform'], ({ result }) => {
    result.$$('//text()[.="Infinity" or .="-Infinity" or .="NaN" or .="NaN d�as" or .="0.0" or .="0.0%" or .="(0.0)" or .="0.00" or .="0" or .="(0)" or .="$0"]').remove();
    xo.state.hide_empty && result.$$('//*[contains(@class,"remove-row-if-empty")][not(.//text())]//ancestor-or-self::html:tr').remove()
})