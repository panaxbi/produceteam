xo.spaces["expanded"] = "http://panax.io/state/expanded";
xo.spaces["visible"] = "http://panax.io/state/visible";
xo.spaces["hidden"] = "http://panax.io/state/hidden";

function onGoogleLogin(response) {
    const responsePayload = xover.cryptography.decodeJwt(response.credential);
    if ((xover.session.status || "unauthorized") == "unauthorized" && xover.session.id_token != response.credential) {
        xover.session.user_login = responsePayload.email;
        xover.session.id_token = response.credential;
        xover.session.login(xover.session.user_login, response.credential).catch(() => {
            xover.session.id_token = undefined;
        })
    }
}

xover.listener.on('beforeRender::#login', function () {
    if (xo.session.status != 'authorizing') {
        [...document.querySelectorAll(`script[src*="accounts.google.com"]`)].remove()
    }
})

async function progressiveRequest(params) {
    if (params instanceof Array) {
        params = Object.fromEntries(params);
    }
    let store = xo.stores.seed;
    if (store.selectFirst(`/model/fechas`)) {
        params["@get_dims"] = 0;
    }
    let response = {};
    let source = this;
    let loading, progress;
    if (Object.keys(params).filter(key => key.match(/@get_n\d/)).length) {
        this.settings.progress = await xo.sources["loading.xslt"].render();
        progress = this.settings.progress[0].querySelector('i progress');
        progress.style.display = 'inline';
    }
    let requested_levels = Object.entries(params).filter(([key, value]) => key.match(/@get_n\d/) && value == 1).map(([key]) => key.replace(/@get_n(\d+)/, '$1')).order();
    //Object.keys(params).filter(key => key.match(/@get_n\d/)).forEach((key, ix) => {
    //    if (ix == 0) {
    let new_params = params;//Object.fromEntries(Object.entries(params).filter(([key]) => !key.match(/@get_n\d/)));
    //new_params[key] = params[key];
    progress && progress.appendAfter(xo.xml.createNode(`<label xmlns="http://www.w3.org/1999/xhtml" style="white-space: nowrap; font-size: xx-small; transform: translateY(-40px); color: white; font-weight: bolder;">Cargando nivel ${requested_levels.join(', ')}...</label>`));
    response = xo.server.request.call(this, new_params, { source: source, progress: progress }).then(document => {
        //delete params[key];
        let items = document.select(`/model/polizas|/model/presupuesto`).filter(item => item.firstElementChild);
        document.seed();

        let current_date_er = new Date().toISOString().replace('-', '').substring(0, 6);
        let fechas = document.selectFirst(`model/fechas`);
        if (fechas) {
            fechas.set("state:current_date_er", current_date_er);
        }

        let target_model = store.selectFirst(`/model`);
        if (target_model) {
            //store.document.disconnect();
            for (item of items) {
                let dims = item.select(`@div|@rs|@un`);
                let levels = [...new Set(item.select(`*/@n1|*/@n2|*/@n3|*/@n4|*/@n5|*/@n6`).map(n => n.value))];
                let matches = target_model.select(`${item.nodeName}${dims.map(el => `[@${el.name}="${el.value}"]`).join('')}`);
                if (!matches.length) {
                    target_model.append(item)
                } else {
                    for (let target of matches) {
                        target.select(`*/@n1|*/@n2|*/@n3|*/@n4|*/@n5|*/@n6`).filter(attr => levels.includes(attr.value)).forEach(attr => attr.remove({ silent: true }));
                        target.select(`*[not(@n1 or @n2 or @n3 or @n4 or @n5 or @n6)]`).forEach(el => el.remove({ silent: true }));
                        target.append(...item.select('*'));
                    }
                }
                //xo.stores.seed.select(`/model/polizas/*/@n${key.substring(6)}`).forEach(el => Element.remove.apply(el.parentNode));
                //xo.stores.seed.select(`/model/presupuesto/*/@n${key.substring(6)}`).forEach(el => Element.remove.apply(el.parentNode));
                //xo.stores.seed.select('//model').forEach(polizas => polizas.append(...document.select('//model/polizas'), { silent: true }));
                //xo.stores.seed.select('/model').forEach(polizas => polizas.append(...document.select('/model/presupuesto'), { silent: true }));
            }
            xo.stores.seed.document.connect();
        }

        //progressiveRequest.call(this, params);
        xo.stores.seed.render();
        if (xo.stores.seed.documentElement) {
            return Promise.resolve(xo.stores.seed.document);
        } else {
            return Promise.resolve(document);
        }
    }).catch(e => {
        return Promise.reject(e);
    }).finally(() => {
        loading && loading.forEach(el => el.remove());
    });
    //    }
    //});
    return response;
}

xo.listener.on(['beforeFetch::#ventas_por_fecha_embarque', 'beforeFetch::#KPI_ventas'], async function ({ settings = {} }) {
    return;
    settings.progress = await xo.sources["loading.xslt"].render()
    for (let render of settings.progress) {
        progress = render.querySelector('i progress');
        progress.style.display = 'inline';
    }
})

xo.listener.on(['xo.Source:fetch', 'xo.Source:failure'], async function ({ settings = {} }) {
    let progress = await settings.progress || [];
    for (let render of progress) {
        let progress = render.querySelector('i progress');
        progress.value = 100;
    }
    progress.remove();

})

Object.defineProperty(xo.session, 'login', {
    value: async function (username, password, connection_id) {
        try {
            username = username instanceof HTMLElement ? username.value : username;
            password = password instanceof HTMLElement ? xover.cryptography.encodeMD5(password.value) : password;
            xover.session.user_login = username
            xover.session.status = 'authorizing';
            await xover.server.login(new URLSearchParams({ 'connection_id': connection_id }), { headers: { authorization: `Basic ${btoa(username + ':' + password)}` } }, (return_value, request) => { xo.session[`${request.url.host}:id`] = return_value.id }); //response.headers.get("x-session-id")
            xover.session.status = 'authorized';
            xover.stores.active.render();
        } catch (e) {
            xover.session.status = 'unauthorized';
            [...document.querySelectorAll(`script[src*="accounts.google.com"]`)].remove()
            Promise.reject(e);
        }
    }, writable: true, configurable: true
})

Object.defineProperty(xo.session, 'logout', {
    value: async function () {
        try {
            let response = await xover.server.logout();
            for (store in xo.stores) {
                xo.stores[store].remove()
            }
            xover.session.status = 'unauthorized';
            history.go(-xo.site.position + 1);
        } catch (e) {
            Promise.reject(e);
        }
    }, writable: true, configurable: true
})

xo.listener.on('beforeRender?!store.stylesheets.length::model[not(//processing-instruction())]', function ({ document, store }) {
    let tag = store.tag;
    store.addStylesheet({ href: tag.substring(1).split(/\?/, 1).shift() + '.xslt', target: "@#shell main" });
})

xo.listener.on('hashchange', function () {
    typeof (toggleSidebar) === 'function' && toggleSidebar(false)
})

xo.listener.on('progress', async function ({ percent }) {
    let progress = await this.settings.progress || [];
    if (progress.length) {
        progress = [progress].flat(Infinity);
        let target = progress[0].parentNode?.querySelector('progress');
        if (target) {
            target.style.display = 'inline'
            target.value = percent;
        }
    }
})

xo.listener.on(['beforeRender::#shell.xslt', 'beforeAppendTo::main', 'beforeAppendTo::body'], function ({ target }) {
    if (!(event.detail.args || []).filter(el => !(el instanceof Comment || el instanceof HTMLStyleElement || el instanceof HTMLScriptElement || el.matches("dialog,[role=alertdialog],[role=alert],[role=dialog],[role=status],[role=progressbar]"))).length) return;
    [...target.childNodes].filter(el => el.matches && !el.matches(`script,dialog,[role=alertdialog],[role=alert],[role=dialog],[role=status],[role=progressbar]`)).removeAll()
})

xo.listener.on('set::fecha/@state:checked', function ({ value, event }) {
    this.parentNode.select("//model/fechas/@state:current_date_er").remove()
    //if (!(event.target instanceof SVGElement)) {
    //    this.parentNode.select("parent::fechas/fecha/@state:checked").filter(attr => attr != this).removeAll();
    //}
    if (value == 'true') {
        let current_year = this.parentNode.getAttribute('mes').substring(0, 4);
        let expanded_array = xo.state.expanded;
        for (let [obj, expanded] of [...expanded_array || []]) {
            let config = JSON.parse(obj);
            let account_list = this.ownerDocument.select(`/model//cuenta[@id=${config.cta || "@id"}]/*/ancestor-or-self::cuenta[@n<=${isFinite(expanded) ? expanded : "@n"}]/@id`).map(n => n.value);
            let matches = this.selectFirst(`/model/*${Object.entries(config).filter(([key]) => key != 'cta').map(([key, value]) => `[@${key}="${value}"]`).join('')}/@fecha[starts-with(.,'${current_year}')]`);
            if (!matches) expanded_array.delete(obj);
        }
    }
}, true)

xo.listener.on('change::model/*/*/@state:checked[.="true"]', function ({ element, stylesheet, srcElement, value, old }) {
    let id = element.getAttributeNode("id") || element.getAttributeNode("mes")
    if (!(srcElement instanceof SVGElement)) {
        if (value) {
            element.select(`../${element.nodeName}[not(@${id.nodeName}="${id}")]/@state:checked`).remove()
        }
    }
})

xo.listener.on('change::razon_social/@state:checked[.="true"]|unidad_negocio/@state:checked[.="true"]', function ({ element, stylesheet, srcElement, value, old }) {
    element.select("@div").map(div => div.parentNode.select(`//model/divisiones/division[@id="${div.value}"][not(@state:checked)]`).set("state:checked", value))
})

xo.listener.on('change::divisiones/division/@state:checked', function ({ target, stylesheet, srcElement, value, old }) {
    let div = this.parentNode.selectFirst("@id");
    if (eval(old)) {
        div.parentNode.select(`//model/razones_sociales/razon_social[@div="${div}"]/@state:checked`).remove()
        div.parentNode.select(`//model/unidades_negocio/unidad_negocio/@state:checked`).remove()
    }
})

function DynamicObject(obj) {
    if (!(this instanceof DynamicObject)) return new DynamicObject(obj);
    let proxy_manager = function (target, name) {
        let return_value
        if (["getValue", "hasOwnProperty", "realValue"].includes(name) || typeof target[name] === 'function') {
            return target[name];
        }
        if (name in target && target[name] !== undefined && target[name] !== null) {
            if (typeof (target[name]) == 'string') {
                return_value = new String(target[name]);
            } else if (typeof (target[name]) == 'number') {
                return_value = new Number(target[name]);
            } else if (typeof (target[name]) == 'boolean') {
                return_value = new Boolean(target[name]);
            } else if (target[name].constructor === {}.constructor) {
                return_value = new Proxy(target[name], { get: proxy_manager });
            } else {
                return_value = target[name];
            }
        } else {
            return_value = new Proxy({}, { get: proxy_manager });
            Object.setPrototypeOf(return_value, Array.prototype)
            Object.defineProperty(return_value, 'realValue', {
                value: undefined,
                writable: true, enumerable: false, configurable: false
            });
        }
        if (!(return_value.hasOwnProperty('getValue'))) {
            Object.defineProperty(return_value, 'getValue', {
                value: function () {
                    if (this.hasOwnProperty('realValue')) {
                        return this.realValue;
                    } else {
                        return target[name];
                    }
                },
                writable: false, enumerable: false, configurable: false
            });
        }
        return return_value;
    }
    let new_obj = new Proxy(obj, { get: proxy_manager });
    Object.setPrototypeOf(new_obj, this);
    return new_obj;
}

xo.listener.on('beforeTransform?stylesheet.href=^page_controls.*\\.xslt?stylesheet.href=page_navbar.xslt::model', function ({ target, store, stylesheet }) { //remueve todos los facts
    let explicit_dims = ["fechas", "mantenibles"];
    this.select(`/model/*[not(*[@id] or ${explicit_dims.map(dim => `self::${dim}`).join(" or ")})]|/model/*[line]`).forEach(el => Element.remove.apply(el));
})

xo.listener.on('beforeTransform::model', function ({ target, store, stylesheet }) {
    this.select(`//razones_sociales[not(@state:checked)][not(razon_social[2])]/razon_social`).forEach(target => target.setAttribute("state:checked", "true"));
    this.select(`//divisiones[not(@state:checked)][not(division[2])]/division`).forEach(target => target.setAttribute("state:checked", "true"));
})

xo.listener.on('beforeTransform::model', function ({ target, store, stylesheet }) {
    this.select(`//divisiones/division[not(@id=//razones_sociales/razon_social/@div)]`).forEach(division => division.remove())
})

xo.listener.on('beforeTransform?stylesheet.href=^page_controls.*\\.xslt?stylesheet.href=page_navbar.xslt::model', function ({ target, store, stylesheet }) { //remueve todos los facts
    let dims = ["fechas"];
    !event.detail.keep_DIVS && this.select(`/model[razones_sociales/razon_social[@state:checked="true"]]/divisiones/division[not(@state:checked="true")]/@nom`).forEach(el => el.parentNode.replaceWith(new Comment(`${el.parentNode.nodeName}: ${el.value}`)));
    this.select(`/model[not(razones_sociales/razon_social[@state:checked="true"])]/unidades_negocio/unidad_negocio`).forEach(el => Element.remove.apply(el));
})

xo.listener.on('beforeTransform?stylesheet.href=title.xslt?stylesheet.href=shell_buttons.xslt?stylesheet.href=page_navbar.xslt?stylesheet.href=^page_controls\\..*\\.xslt::model', function ({ stylesheet }) {
    event.detail.keepDimensions = true;
    event.stopImmediatePropagation()
})

xo.listener.on(['replaceWith::[xo-stylesheet="page_controls.mantenibles.xslt"]'], ({ new_node, old }) => {
    if (!new_node.childNodes.length) {
        new_node.replaceChildren(...old.childNodes)
        //new_node.querySelectorAll("[xo-stylesheet]").toArray().concat([new_node].filter(el => el.matches("[xo-stylesheet]")))
    }
})

xo.listener.on(['transform'], ({ result }) => {
    result.$$('//text()[.="Infinity" or .="-Infinity" or .="NaN" or .="NaN días" or .="0.0" or .="0.0%" or .="(0.0)" or .="0.00" or .="0" or .="(0)" or .="$0"]').remove()
})
async function submit(node) {
    let progress = await xo.sources["loading.xslt"].render();
    if (node.filter('//security').pop()) {
        let response = await xo.server.applyPermissions(xo.xml.createDocument(node));
        response.render()
    } else {
        return Promise.reject("No implementado")
    }
    progress.remove();
}

async function generateExcelFile(table, name) {
    let progress = await xo.sources["loading.xslt"].render();
    await xover.delay(500);
    //if (this.Interval) window.clearInterval(this.Interval);
    let _progress = 0;
    let progress_bar = progress[0].querySelector('progress');
    progress_bar.style.display = 'inline';

    //this.Interval = setInterval(function () {
    //    if (progress_bar) {
    //        progress_bar.value = _progress;
    //        console.log(_progress);
    //    }
    //}, 500);
    table = table.cloneNode(true);
    table.querySelectorAll('del,.hidden').toArray().remove();
    let set_computed_background = function (cell) {
        let border = cell.style.border;
        let backgroundColor = cell.style.backgroundColor;
        let color = cell.style.color;
        let styleSheets = document.styleSheets;
        for (let styleSheet of [...styleSheets]) {
            try {
                for (let rule of [...styleSheet.rules].filter(rule => rule.selectorText && (rule.style.border || rule.style.backgroundColor || rule.style.color) && cell.matches(rule.selectorText))) {
                    if (!border && rule.style.border) {
                        cell.style.border = rule.style.border;
                    }
                    if (!backgroundColor && rule.style.backgroundColor) {
                        cell.style.backgroundColor = rule.style.backgroundColor;
                    }
                    if (!color && rule.style.color) {
                        cell.style.color = rule.style.color;
                    }
                }
            } catch (e) {
                console.warn(e)
            }
        }
    }
    let rows = table.getElementsByTagName("tr");
    let r = 0;
    for (let row of rows) {
        ++r;
        _progress = r / rows.length * 100;
        [...row.getElementsByTagName("td")].forEach(el => set_computed_background(el));
        if (r % (rows.length / 10) == 0) {
            progress_bar.value = _progress;
            await xover.delay(500);
        }
    }
    xo.dom.toExcel(table, name.split("?")[0])
    progress.remove();
    if (this.Interval) window.clearInterval(this.Interval);
}

xo.listener.on("mousedown", function (event) {
    if (!(event && event.buttons == 1 && (this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') && window.getComputedStyle(this).cursor == 'cell'))) return
    let parent_container = this.closest("table, tbody, .validation-enabled, .blacklist-enabled, .selection-enabled");
    if (!parent_container) return;
    let parent_cell = this.closest('.cell,td,th');
    if (parent_cell && parent_container && !(event && (event.ctrlKey || event.shiftKey))) {
        [...parent_container.querySelectorAll(".selected svg.bi-box-arrow-up-right")].filter(svg => !parent_cell.contains(svg)).forEach(svg => { svg.remove() });
        [...parent_container.querySelectorAll(".selected,.selection-begin,.selection-end,.top-selection,.bottom-selection,.left-selection,.right-selection")].forEach(cell => { cell.classList.remove("selected", "selection-begin", "selection-end", "top-selection", "bottom-selection", "left-selection", "right-selection") });
    }
    let cell = window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell");
    if (cell) {
        if (event && (event.ctrlKey || event.shiftKey) && [...parent_cell.classList].some(el => ["selected", "selection-end", "selection-begin"].includes(el))) {
            parent_cell.classList.remove("selected", "selection-begin", "selection-end")
        } else {
            cell.classList.add("selected");
            cell.classList.add("selection-begin");
        }

        //console.log(event.target);
        event.stopPropagation();
        event.preventDefault();
        event.cancelBubble = true;
        event.returnValue = false;
    }
    xo.state.validate = !!(xo.state.validations || selection.cells.find(cell => cell.closest('.validation-enabled')));
    xo.state.blacklist = !!(xo.state.blacklist_items || selection.cells.find(cell => cell.closest('.blacklist-enabled')));
    this.closest(".cell") && selection.cells.length && selection.cells.showInfo();
})

xo.listener.on("mousemove", async function (event) {
    if (!(event && event.buttons == 1 && (this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell'))) return
    let parent_container = this.closest("table, tbody, .validation-enabled, .blacklist-enabled, .selection-enabled");
    if (parent_container) {
        let selection_started = parent_container.querySelector(".selection-begin");
        if (!selection_started) return;
        let selection_end = parent_container.querySelector(".selection-end");
        if (selection_end) return;
        //let classList = [...this.classList];
        //let classDomains = [...selection_started.classList].filter(cl => cl.indexOf("domain-") == 0);
        //if ((!classDomains.length || classDomains.every(cl => classList.includes(cl))) && parent_container.contains(selection_started) && !selection_end) {
        //    this.classList.add("selected");
        //}
        xo.state.validate = !!(xo.state.validations || selection.cells.find(cell => cell.closest('.validation-enabled')));
        xo.state.blacklist = !!(xo.state.blacklist_items || selection.cells.find(cell => cell.closest('.blacklist-enabled')));
        selectCells(selection_started, window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell"));
        this.closest(".cell") && selection.cells.showInfo();
    }
})

xo.listener.on("mouseup", function (event) {
    if (!(this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell')) return;
    if (this instanceof HTMLTableCellElement && this.matches(".cell") && !(this.matches(".presupuesto"))) {
        [...this.querySelectorAll("a.auxiliar-polizas")].removeAll();
        let cell = this;
        let attributes = cell.select("ancestor-or-self::*/@div[1]|ancestor-or-self::*/@rs[1]|ancestor-or-self::*/@un[1]|ancestor-or-self::*/@cta[1]|ancestor-or-self::*/@cl[1]|ancestor-or-self::*/@fecha[1]|ancestor-or-self::*/@tipo[1]").reduce((obj, attr) => { obj['@' + attr.name] = attr.value || ''; return obj }, {})
        if (attributes["@fecha"] != '' && (attributes["@fecha"] || '').indexOf('~') == -1 && (attributes["@cta"] || attributes["@cl"]) && attributes["@rs"]) {
            if (this.closest('.presupuestos')) attributes["@tipo"] = 'presupuesto'
            let url_params = new URLSearchParams(attributes);
            let div = document.createElement('div');
            div.innerHTML = (`<a class="auxiliar-polizas" href="#polizas?${decodeURIComponent(url_params.toString())}" style="text-decoration: none; color: currentColor; margin-left: 5pt;"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-up-right" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.636 3.5a.5.5 0 0 0-.5-.5H1.5A1.5 1.5 0 0 0 0 4.5v10A1.5 1.5 0 0 0 1.5 16h10a1.5 1.5 0 0 0 1.5-1.5V7.864a.5.5 0 0 0-1 0V14.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5z"/><path fill-rule="evenodd" d="M16 .5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793L6.146 9.146a.5.5 0 1 0 .708.708L15 1.707V5.5a.5.5 0 0 0 1 0v-5z"/></svg></a>`)
            let link = div.firstChild;
            cell.append(link);
        }
    }
    let parent_container = this.closest("table, tbody");
    if (parent_container) {
        let selection_started = parent_container.querySelector(".selection-begin");
        let cells = selection.cells;
        if (selection_started) {
            let cell = window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell");
            cell && cell.classList.add("selection-end");
            let offcanvas = this.closest(".cell") && document.querySelector('#offcanvasSelection');
            if (offcanvas) {
                new bootstrap.Offcanvas(offcanvas).toggle()
                //let rows = parent_container.querySelectorAll("tr:has(.cell.selected)"); // Esta parte del código tiene problemas de rendimiento con datasets grandes por recálculos en estilos
                //for (let [r, row] of rows.entries()) {
                //    if (r == 0) row.classList.add("top-selection");
                //    if (r == rows.length - 1) row.classList.add("bottom-selection");
                //    let cols = row.querySelectorAll(".cell.selected");
                //    for (let [c, col] of cols.entries()) {
                //        if (c == 0) col.classList.add("left-selection");
                //        if (c == cols.length - 1) col.classList.add("right-selection");
                //    }
                //}
                xo.state.validate = !!(xo.state.validations || cells.find(cell => cell.closest('.validation-enabled')));
                xo.state.blacklist = !!(xo.state.blacklist_items || cells.find(cell => cell.closest('.blacklist-enabled')));
                cells.showInfo();
            }
        } else {
            cells.showInfo();
        }
    }
})

selectCells = function (selection_started, selection_end) {
    //xover.manager.delay.set(selection_started, xover.manager.delay.get(selection_started) || xover.delay(1).then(() => {
    if (!selection_end) selection_end = selection_started;
    selection_started
    let [ix, iy] = [selection_started.closest("td,th,tbody,table,body").cellIndex, selection_started.closest("tr,tbody,table,body").rowIndex];
    let [ex, ey] = [selection_end.closest("td,th,tbody,table,body").cellIndex, selection_end.closest("tr,tbody,table,body").rowIndex];

    if (ix > ex) [ix, ex] = [ex, ix];
    if (iy > ey) [iy, ey] = [ey, iy];

    let parent_container = selection_end.closest("tbody,table");
    let oy = parent_container.rows[0].rowIndex;
    iy = iy - oy;
    ey = ey - oy;
    let classDomains = [...selection_started.classList].filter(cl => cl.indexOf("domain-") == 0);
    parent_container && [...parent_container.querySelectorAll(".cell.selected")].forEach(cell => { cell.classList.remove("selected", "border-top", "border-right", "border-bottom", "border-left") });
    for (let r = iy; r <= ey; ++r) {
        for (let c = ix; c <= ex; ++c) {
            let row = parent_container.rows[r] || null;
            let target = row && row.cells[c] || null;
            if (!target) continue;
            let classList = target && [...target.classList];
            if ((!classDomains.length || classDomains.every(cl => classList.includes(cl))) && parent_container.contains(selection_started)) {
                target.classList.add("selected");
                //selection_end.classList.add("selection-end"); // Esta parte del código tiene problemas de rendimiento con datasets grandes por recálculos en estilos
                //target.classList[(c == ix) ? 'add' : 'remove']("border-left");
                //target.classList[(c == ex) ? 'add' : 'remove']("border-right");
                //target.classList[(r == iy) ? 'add' : 'remove']("border-top");
                //target.classList[(r == ey) ? 'add' : 'remove']("border-bottom");
            }
        }
    }
    //}).catch((e) => {
    //    return Promise.reject(e)
    //}).finally(async () => {
    //    xover.manager.delay.delete(selection_started);
    //}));
    //return xover.manager.delay.get(selection_started);
}

let selection = {};
Object.defineProperty(selection, 'cells', {
    get: function () {
        let result = [...document.querySelectorAll(".selected")];

        Object.defineProperty(result, 'showInfo', {
            value: function () {
                let selection = this;
                let target = document.forms['selection'];
                if (!target) return;

                let formatValue = function (node) {
                    let value;
                    if (!node) {
                        value = null;
                    } else if (['days'].includes(node.name)) {
                        value = new Intl.NumberFormat().format(node.value)
                    } else {
                        value = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(node.value)
                    }
                    return value;
                }
                let sum = selection.sum();
                //let map = selection.groupDimensions()
                let config = selection.every(el => el.classList.contains("money")) ? { style: 'currency', currency: 'USD' } : {};
                target.querySelector('.valor').classList.remove('d-none');
                target.valor.value = !isNaN(sum) ? new Intl.NumberFormat('en-US', config).format(sum) : sum;
                let detalle = target.querySelector('.detalle');
                if (detalle) {
                    detalle.classList.add('d-none')
                    if (isNaN(sum) && detalle && sum.match(/^\d{3}-\d{3}/)) {
                        detalle.classList.remove('d-none')
                        let link = detalle.querySelector('a')
                        let url = xover.URL(link.href);
                        let [tag, search = ''] = url.hash.split("?");
                        let searchParams = new URLSearchParams(search);
                        searchParams.set("@account", `'${sum}'`)
                        url.hash = tag + '?' + searchParams.toString()
                        link.href = url.href;
                    }
                }

                target.querySelector('.formula').classList.add('d-none');
                if (selection.length == 1) {
                    let el = selection[0];
                    let scope = el.scope;
                    let formula = el.getAttribute("formula");
                    if (formula) {
                        target.querySelector('.valor').classList.add('d-none');
                        target.querySelector('.formula').classList.remove('d-none');
                        target.querySelector('label').textContent = formula + ' = ';
                        if (scope) {
                            target.querySelector('code').innerHTML = formula.replace(/@[\w]+/g, (match) => `<var title="${match.substr(1)}">${formatValue(scope.getAttributeNode(match.substr(1)))}</var>`);
                        }
                    }
                }
            }, writable: false, configurable: false, enumerable: false
        })

        Object.defineProperty(result, 'sum', {
            value: function () {
                let concat = this.some(el => !el.closest('.money,.number'));
                let values = this.map((el, ix, array) => {
                    let dims = ["div", "rs", "un", "prod", "cta", "indicador", "cl", "fecha", "value"];
                    let cell = el.select(dims.map(dim => `ancestor-or-self::*/@${dim}[1]`).join("|")).filter(attr => attr.value).reduce((cell, attr) => { cell[attr.name] = attr.value || ''; return cell }, {});

                    if (!cell.hasOwnProperty("value")) {
                        let value = (el.querySelector("input") || el).value;
                        if (concat) {
                            cell["value"] = value;
                        } else {
                            cell["value"] = parseFloat(value.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                        }
                    }
                    return concat ? cell["value"] : parseFloat(cell["value"] || 0)
                })
                return concat ? (values).distinct().filter(value => value).join(", ") : values.reduce((sum, item) => sum + item, 0)
            }, writable: false, configurable: false, enumerable: false
        })

        Object.defineProperty(result, 'groupDimensions', {
            value: function (...dims) {
                dims = dims.length && dims || ["div", "rs", "un", "prod", "cta", "indicador", "cl", "fecha"];
                let map = { "*": {} };
                this.forEach(el => {
                    for (let attr of el.select(dims.map(dim => `ancestor-or-self::*/@${dim}[1]`).join("|"))) {
                        map[attr.name] = map[attr.name] || {};
                        let scope = el.scope;
                        if (scope.parentNode.nodeName == 'line' && (scope instanceof Attr || scope instanceof Text)) {
                            value = scope;
                        } else {
                            value = parseFloat(el.textContent.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                        }
                        let dim_value = map[attr.name];
                        dim_value[attr.value] = dim_value[attr.value] || new Set();
                        dim_value[attr.value].add(value);
                        map["*"][value.nodeName] = map["*"][value.nodeName] || new Set();
                        map["*"][value.nodeName].add(value);
                    }
                })
                return map;
            }, writable: false, configurable: false, enumerable: false
        })

        Object.defineProperty(result, 'fix', {
            value: function (valid) {
                let validations = xo.site.state.validations || [];
                let selection = this.map(el => {
                    el.classList.remove("valid", "invalid")
                    let cell = el.select("ancestor-or-self::*/@div[1]|ancestor-or-self::*/@rs[1]|ancestor-or-self::*/@un[1]|ancestor-or-self::*/@cta[1]|ancestor-or-self::*/@indicador[1]|ancestor-or-self::*/@cl[1]|ancestor-or-self::*/@fecha[1]|ancestor-or-self::*/@value[1]").filter(attr => attr.value).reduce((cell, attr) => { cell[attr.name] = attr.value || ''; return cell }, {});

                    let value;
                    if (!cell.hasOwnProperty("value")) {
                        cell["value"] = parseFloat(el.textContent.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                    }
                    if (valid) {
                        value = cell["value"];
                    } else {
                        value = prompt(`Cuál debe ser el valor para ${Object.entries(cell).reduce((values, [key, value]) => { values.push(`${key}:${value}`); return values }, []).join(', ')}`);
                    }
                    if (value != undefined) {
                        cell["value"] = parseFloat(cell["value"]).toFixed(4);
                        value = parseFloat(value).toFixed(4);
                        if (cell.fecha && (cell.cta || cell.indicador || cell.cl) && (cell.div || cell.rs)) {
                            if (value == cell["value"]) {
                                el.classList.add("valid")
                            } else {
                                el.classList.add("invalid")
                            }
                        }
                        cell["value"] = value;
                        return cell;
                    }
                }).filter(el => el);
                selection = validations.concat(selection.filter(obj => obj.fecha && (obj.cta || obj.cl || obj.indicador)));
                xo.site.state.validations = selection;
                xo.site.save();
            }, writable: false, configurable: false, enumerable: false
        })
        return result;
    }
});

xo.listener.on(`change::row/@*[not(contains(namespace-uri(),'http://panax.io/state') or contains(namespace-uri(),'http://panax.io/metadata'))]`, function ({ element: row, attribute, value, old }) {
    let initial_value = row.getAttributeNodeNS('http://panax.io/state/initial', attribute.nodeName.replace(':', '-'));
    if (!initial_value) {
        row.set(`initial:${attribute.nodeName.replace(':', '-')}`, old);
    } else if (value == initial_value.value) {
        initial_value.remove();
    }

    let initial_attributes = row.select("@initial:*");
    if (initial_attributes.some(el => el.value != el.parentNode.getAttribute(el.localName))) {
        row.set(`state:dirty`, 1);
    } else {
        row.removeAttribute(`state:dirty`)
    }
});

xo.listener.on('click::.selected.editable.selection-begin.selection-end', function () {
    let cell = this.closest(".selected.editable[xo-slot]");
    if (!cell) return;
    let scope = cell.scope;
    if (!(scope/* && scope.matches("@ppto")*/)) return;

    const content = cell.textContent;

    const input = document.createElement('input');
    const children = [...cell.childNodes];
    input.type = 'text';
    input.value = content.trim();

    try {
        cell.replaceChildren(input);
    } catch (e) {

    }

    input.focus();
    input.select();
    input.addEventListener('blur', function () {
        cell.replaceChildren(...children)
    });
    input.addEventListener('keydown', function () {
        if (event.keyCode == 13) {
            input.blur()
        }
    });
    input.addEventListener('input', function (event) {
        let [current_caret] = xover.dom.getCaretPosition(input);
        let value = input.value;

        let previous = value.substring(0, current_caret);
        //let separators = [...previous.matchAll(/[^\d.]/g)].length;
        let new_value = value.replace(/[^\d.]/g, '').replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        if (event.inputType === 'deleteContentForward' && new_value[current_caret] == ',') {
            active_caret = current_caret + 1
        } else if (event.inputType != 'deleteContentForward' && new_value[current_caret - 1] == ',') {
            active_caret = current_caret - 1
        } else if (event.inputType === 'insertText' && new_value[current_caret] != ',' && new_value[current_caret - 1] != ',' && new_value[current_caret - 2] != ',') {
            active_caret = previous.length + 1
        } else {
            active_caret = current_caret
        }
        //console.log({ previous, separators, new_value, current_caret, active_caret, value })

        input.value = new_value;
        xover.dom.setCaretPosition(input, [active_caret]);
        selection.cells.showInfo()
    });
    input.addEventListener('change', function () {
        scope.value = this.value;
    });
})
xo.listener.on(['append::dialog[open]'], function () {
    this.close()
    this.showModal()
})

xo.listener.on(`input::input[type=search]`, function (event) {
    const input = this;
    clearTimeout(input.search_timeout);
    this.search_timeout = setTimeout(() => {
        //let scope = input.scope;
        //scope.value = input.value;
        let search_text = input.value;//this.documentElement.getAttribute("state:filter");
        let inverted = search_text[0] == '!';
        search_text = search_text.replace(/^\!/, '');
        let records = this.closest('table,form').select(`.//tr/@desc_poliza|.//select/option/text()`)
        records.forEach(record => record.parentNode.classList.remove('hidden'));
        for (let attr of records.filter(desc => inverted !== !desc.value.match(new RegExp(search_text, "ig")))) {
            attr.parentNode.classList.add('hidden')
        }
        clearTimeout(input.search_timeout);
    }, 100);
});

xo.listener.on(`change::@state:date`, function ({ value, event }) {
    let srcElement = event.srcElement;
    let store = srcElement.store;
    if (!store) return;
    store.source.definition["server:request"]["@month"] = value;
    store.document.fetch();
})

xo.listener.on(`beforeTransform?stylesheet.href=estado_resultados_semanal.xslt`, function ({ document }) {
    let start_week = this.selectFirst(`//fechas/@state:start_week`)
    if (start_week) {
        this.select(`//fechas/row[@desc="${start_week}"]`).forEach(el => el.select(`preceding-sibling::*`).remove())
    }
    let end_week = this.selectFirst(`//fechas/@state:end_week`)
    if (end_week) {
        this.select(`//fechas/row[@desc="${end_week}"]`).forEach(el => el.select(`following-sibling::*`).remove())
    }
})

xo.listener.on(`beforeTransform?stylesheet.href=ventas_por_fecha_embarque.xslt`, function ({ document }) {
    for (let attr of [...this.documentElement.attributes].filter(attr => attr.namespaceURI == 'http://panax.io/state/filter')) {
        this.select(`//ventas/row[${attr.value.split("|").map(value => `@${attr.localName}!="${value}"`).join(" and ")}]`).forEach(el => el.remove())
    }

    let amt = this.select(`//ventas/row/@amt`).reduce(Sum, 0);
    let qtym = this.select(`//ventas/row/@qtym`).reduce(Sum, 0);
    this.selectFirst(`//ventas`).setAttribute(`state:avg_upce`, amt / qtym);
    let tcos = this.select(`//ventas/row/@tcos`).reduce(Sum, 0);
    let amt_ad = this.select(`//ventas/row/@amt_ad`).reduce(Sum, 0);
    this.selectFirst(`//ventas`).setAttribute(`state:avg_pce`, (amt - tcos - amt_ad) / qtym);

})

xo.listener.on(`beforeTransform::model[*/@filter:*]`, function ({ document }) {
    for (let attr of this.select(`//@filter:*`)) {
        attr.parentNode.select(`row[${attr.value.split("|").map(value => `not(@${attr.localName}="${value}")`).join(" and ")}]`).forEach(el => el.remove())
    }
})

xo.listener.on(`beforeTransform::model[*/@group:*]`, function ({ document }) {
    for (let attr of this.select(`//@group:*`)) {
        let group_node = xover.xml.createElement(attr.name);
        for (let value of attr.parentNode.select(`row/@${attr.localName}`).distinct()) {
            let row = xover.xml.createElement("row");
            row.setAttribute("desc", value);
            group_node.append(row);
        }
        document.documentElement.prepend(group_node);
    }
})

xo.listener.on([`beforeTransform::model[*/@filter:*]`, `beforeTransform?stylesheet.href=auxiliar_cuentas.xslt`], function () {
    for (let attr of this.select(`//@filter:*`)) {
        this.select(`//movimientos/row[not(@xsi:type="mock")][${attr.value.split("|").map(value => `@${attr.localName}!="${value}"`).join(" and ")}]`).forEach(el => el.remove())
    }
})

xo.listener.on("fetch::xo:response", function () {
    let new_node = this.selectFirst('xo:response//model');
    new_node instanceof Element && this.documentElement.replaceWith(new_node)
})

xo.listener.on('beforeRender::html:dialog', function ({ element }) {
    if ([...document.querySelectorAll('dialog')].find(dialog => dialog.isEqualNode(element))) {
        event.preventDefault()
    }
})

xo.listener.skipSelector(".dropdown-menu.show")

mostrarGrafica = function () {
    let chart = document.getElementById('myChart');
    let offcanvas = chart.closest('.offcanvas');
    offcanvas && bootstrap.Offcanvas.getOrCreateInstance(offcanvas).show()
}

createCommand = function (params = {}) {
    return Object.entries(params).filter(entry => entry[0][0] != '^').map(([field, value], ix) => field == 'command' ? `EXEC ${value} ` : `${(ix > 1 ? ', ' : '') + field}='${value}'`).join('')
}

xo.listener.on('mutate::html', function ({ mutations }) {
    if (mutations.size > 10) {
        mutations.clear();
    }
})

xover.listener.on('Response:failure?status=401', function ({ url }) {
    if (['server.panax.io'].includes(url.host)) {
        xo.session.status = 'unauthorized'
    }
})

xover.listener.on(`beforeFetch?request`, function ({ request }) {
    let session_id = request.headers.get("x-session-id") || xo.session[`${request.url.host}:id`];
    session_id && request.headers.set("x-session-id", session_id)
})

xover.listener.on([`beforeFetch::#detalle_gastos_operativos`, `beforeFetch::#detalle_ingresos_operativos`, `beforeFetch::#ingresos_operativos`, `beforeFetch::#gastos_operativos`, `beforeFetch::#auxiliar_cuentas`, `beforeFetch::#balance_operativo`, `beforeFetch::#detalle_problemas`], function ({ source, document, parameters }) {
    delete parameters["@fecha_inicio"];
    delete parameters["@fecha_fin"];
    delete parameters["@start_week"];
    delete parameters["@end_week"];
    delete parameters[`@trouble`]
    delete parameters[`@order`]
    delete parameters[`@purchase_order`]
    delete parameters[`@grower_lot`]

    if (xo.state.filterBy == 'order') {
        parameters[`@order`] = document.selectFirst("//@state:order");
    } else if (xo.state.filterBy == 'purchase_order') {
        parameters[`@purchase_order`] = document.selectFirst("//@state:purchase_order");
    } else if (xo.state.filterBy == 'grower_lot') {
        parameters[`@grower_lot`] = document.selectFirst("//@state:grower_lot");
    } else if (xo.state.filterBy == 'trouble') {
        parameters[`@trouble`] = document.selectFirst("//@state:trouble");
    } else if (xo.state.filterBy == 'dates') {
        parameters["@fecha_inicio"] = document.selectFirst("//@state:fecha_inicio");
        parameters["@fecha_fin"] = document.selectFirst("//@state:fecha_fin");
    } else if ((xo.state.filterBy || 'weeks') == 'weeks') {
        parameters["@start_week"] = document.selectFirst("//semanas/@state:start_week")
        parameters["@end_week"] = document.selectFirst("//semanas/@state:end_week")
    }
    for (let [key, value] of xo.site.searchParams.params) {
        parameters[key] = value
    }
})

xover.listener.on([`beforeFetch::#ventas_por_fecha_embarque`, `beforeFetch::#KPI_ventas`], function ({ source, document, parameters }) {
    delete parameters[`@order`]
    delete parameters[`@purchase_order`]
    delete parameters[`@grower_lot`]
    delete parameters["@fecha_embarque_inicio"];
    delete parameters["@fecha_embarque_fin"];
    delete parameters["@start_week"];
    delete parameters["@end_week"];

    if (xo.state.filterBy == 'order') {
        parameters[`@order`] = document.selectFirst("//@state:order");
    } else if (xo.state.filterBy == 'purchase_order') {
        parameters[`@purchase_order`] = document.selectFirst("//@state:purchase_order");
    } else if (xo.state.filterBy == 'grower_lot') {
        parameters[`@grower_lot`] = document.selectFirst("//@state:grower_lot");
    } else if ((xo.state.filterBy || 'ship_date') == 'ship_date') {
        parameters["@fecha_embarque_inicio"] = document.selectFirst("//@state:fecha_embarque_inicio");
        parameters["@fecha_embarque_fin"] = document.selectFirst("//@state:fecha_embarque_fin");
    }
})

xover.listener.on(`change::@state:fecha_embarque_inicio|@state:fecha_embarque_fin`, function ({ value, store }) {
    xo.state.filterBy = 'ship_date'
    store.fetch()
})

xover.listener.on(`change::@state:order|@state:purchase_order|@state:grower_lot`, function ({ value, store }) {
    xo.state.filterBy = this.localName.toLowerCase()
    store.fetch()
})
xover.listener.on(`change::@state:start_week|@state:end_week`, function ({ element, store }) {
    xo.state.filterBy = 'weeks'
    store.fetch()

})
xover.listener.on(`change::@state:fecha_inicio|@state:fecha_fin`, function ({ element, store }) {
    xo.state.filterBy = 'dates'
    store.fetch()
})

xover.listener.on(`change?xo.site.seed=#estado_resultados_semanal::@state:start_week|@state:end_week`, function () {
    /*Prevents auto fetch*/
    event.stopImmediatePropagation()
})

xover.listener.on(`change::@state:selected`, function ({ value, store }) {
    store.source.definition["server:request"][`@${this.parentNode.localName}`] = value
    store.fetch()
})

mostrarRegistros = function () {
    let scope = this.scope;
    if (!(scope instanceof Attr)) return;
    let store = this.store;
    store.source.definition["server:request"]["@max_records"] = scope.value
    store.fetch()
}

xover.listener.on('click::.filterable', function () {
    if (!selection.cells.length || selection.cells.concat(this).includes(this.closest('td,.cell'))) {
        let filters = selection.cells.concat(this).map(cell => cell.scope).reduce((result, scope) => { result[scope.localName] = (result[scope.localName] || []); result[scope.localName].push(scope.value); return result }, {});
        let scope = this.scope;
        let model = scope.closest("model");
        let target = scope.selectSingleNode(`ancestor::*[parent::model]`);
        if (target.hasAttributeNS('http://panax.io/state/filter', `${scope.localName}`)) {
            target.removeAttributeNS('http://panax.io/state/filter', `${scope.localName}`)
            delete filters[scope.localName]
        }


        for (let key of Object.keys(filters)) {
            target.setAttributeNS('http://panax.io/state/filter', `filter:${key}`, filters[key].distinct().join("|"))
        }
    }
})

xover.listener.on('click::table .sortable', function () {
    sortRows.call(this, this.closest('td,th'))
})

//xover.listener.on('click::table .groupable', function () {
//    let groupBy = this.scope.nodeName.toLowerCase()
//    xo.state.groupBy = xo.state.groupBy == groupBy ? null : groupBy;
//})

xo.listener.on("fetch::#detalle_gastos_operativos|#detalle_ingresos_operativos|#detalle_ingresos|#detalle_egresos", function ({ source }) {
    delete source.definition["server:request"]["@max_records"]

    if (xo.site.searchParams.params.size) {
        debugger
    }
})

xo.listener.on(["fetch"], function ({ document }) {
    //if (document instanceof Comment && document.data == 'ack:empty') {
    //    throw (new Error(`La consulta no regresó un modelo válido. \nEsto es un error. Favor de reportarlo. \nCopie y pegue este código: \n${btoa(JSON.stringify(this.definition))}`));
    //}

    let tr = this.document.selectFirst('//ventas|//movimientos|//trouble');
    if (tr) {
        let node = document.selectFirst('//ventas|//movimientos|//trouble');
        node.ownerDocument.disconnect();
        let attributes = tr.attributes.toArray().filter(attr => !attr.namespaceURI || ["http://panax.io/state/filter", "http://panax.io/state/group"].includes(attr.namespaceURI)).map(slot => slot.cloneNode());
        [...node.attributes].filter(attr => !attr.namespaceURI).remove();
        attributes.forEach(attr => node.setAttributeNode(attr));
    }
})

function sortRows(header) {
    let index = header.$$("preceding-sibling::*").reduce((index, el) => { index += el.colSpan || 0; return index }, 0);
    let direction = 1;
    let getValue = (el) => {
        let val = el.cells[index].getAttribute("value") || el.cells[index].textContent;
        let parsed_value = +val.replace(/\$|^#|,/g, '');
        return isNaN(parsed_value) ? val : parsed_value;
    };
    let compare = (next, curr) => {
        if (curr.classList.contains("header") || next.classList.contains("header")) {
            return 0;
        }
        let valueCurr = getValue(curr);
        let valueNext = getValue(next);
        if (typeof (valueNext.localeCompare) == 'function') {
            return direction * valueNext.localeCompare(valueCurr, undefined, { sensitivity: 'accent', caseFirst: 'upper' });
        } else {
            return direction * (valueNext - valueCurr);
        }
    }
    [...header.parentNode.querySelectorAll('.sorted')].filter(th => th != header).forEach(th => th.classList.remove('sorted-desc', 'sorted-asc', 'sorted'));
    for (let tbody of header.closest('table').select('tbody')) {
        let rows = [...tbody.querySelectorAll("tr")];
        if (header.classList.contains("sorted-desc")) {
            index = 0;
            rows.sort(compare);
        } else if (header.classList.contains("sorted")) {
            direction = -1;
            rows.sort(compare);
        } else {
            rows.sort(compare);
        }
        tbody.replaceChildren(...rows);
    }
    if (header.classList.contains("sorted-desc")) {
        header.classList.remove("sorted", "sorted-desc");
    } else if (header.classList.contains("sorted")) {
        header.classList.remove("sorted-asc");
        header.classList.add("sorted", "sorted-desc");
    } else {
        header.classList.add("sorted", "sorted-asc");
    }
}

xo.listener.on('xover-initialized', function ({ progress_renders }) {
    if ('#loading' in xover.manifest.sources) {
        progress_renders.concat(xover.sources['#loading'].render());
    }
})

xover.listener.on('Response:reject?status=401&bodyType=html', function ({ }) {
    return { "message": "" };
})

xover.listener.on(`columnRearranged`, function () {
    let tr = this.closest('tr');
    let node = tr.scope;
    node.ownerDocument.disconnect();
    let attributes = tr.querySelectorAll(':scope > th').toArray().map(th => th.getAttributeNode("xo-slot")).filter(slot => slot).map(slot => slot.scope.cloneNode());
    [...node.attributes].filter(attr => !attr.namespaceURI).remove();
    attributes.forEach(attr => node.setAttributeNode(attr));
    tr.store.save();
})